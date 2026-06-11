import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ride_request.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/top_header.dart';
import '../data/translations.dart';
import '../services/ride_service.dart';
import '../services/broadcast_service.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../data/sample_rides.dart';
import 'calendar_page.dart';
import 'home_page.dart';
import 'map_page.dart';
import 'request_manage_ride_page.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int currentTab = 1;
  String searchTerm = '';
  final RideService _rideService = RideService();
  final BroadcastService _broadcastService = BroadcastService();
  final AuthService _authService = AuthService();
  String? _lastBroadcastId;
  StreamSubscription? _broadcastSubscription;
  final DateTime _sessionStartTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _listenForBroadcasts();
  }

  @override
  void dispose() {
    _broadcastSubscription?.cancel();
    super.dispose();
  }

  void _listenForBroadcasts() {
    _broadcastSubscription = _broadcastService.latestBroadcasts.listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;

        final Timestamp? timestamp = data['timestamp'];
        final String? targetUid = data['targetUid'];
        final String currentUid = _authService.currentUser?.uid ?? '';
        
        // 1. Freshness Check: Only show if sent AFTER this session started
        if (timestamp != null && timestamp.toDate().isBefore(_sessionStartTime)) {
          return;
        }

        // 2. Targeted Check: 
        // - If targetUid is null, it's global (everyone sees it)
        // - If targetUid exists, ONLY that specific user sees it
        bool isMe = (targetUid != null && targetUid == currentUid);
        bool isGlobal = (targetUid == null);
        bool shouldShow = isGlobal || isMe;

        // 3. Duplicate Check
        if (shouldShow && doc.id != _lastBroadcastId) {
          _lastBroadcastId = doc.id;
          _showBroadcastNotification(data['title'], data['message']);
          
          // Also show a system-level phone notification
          NotificationService.showLocalNotification(data['title'], data['message']);
        }
      }
    });
  }

  void _showBroadcastNotification(String title, String message) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Image.asset('lib/assets/hillcrest-logo.png', width: 30, height: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Dismiss',
              style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  List<RideRequest> _applyFilter(List<RideRequest> allRides) {
    if (searchTerm.trim().isEmpty) {
      return allRides;
    }
    final q = searchTerm.toLowerCase();
    return allRides
        .where(
          (ride) =>
              ride.participantName.toLowerCase().contains(q) ||
              ride.dateLabel.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RideRequest>>(
      stream: _rideService.ridesStream,
      builder: (context, snapshot) {
        // Fallback to sampleRides if database is empty so the map isn't blank
        final rides = (snapshot.data == null || snapshot.data!.isEmpty) 
            ? sampleRides 
            : snapshot.data!;
        final filteredRides = _applyFilter(rides);

        return ValueListenableBuilder(
          valueListenable: TranslationService.currentLanguage,
          builder: (context, lang, _) {
            return Scaffold(
              drawer: const AppDrawer(),
              body: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    TopHeader(
                      onSearchChanged: (value) => setState(() => searchTerm = value),
                      hint: TranslationService.translate('search_hint'),
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: currentTab,
                        children: [
                          MapPage(rides: filteredRides),
                          HomePage(rides: filteredRides),
                          CalendarPage(rides: filteredRides),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: AppTheme.background,
                elevation: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () => setState(() => currentTab = 0),
                          icon: Icon(
                            currentTab == 0 ? Icons.place : Icons.place_outlined,
                            size: 26,
                            color: currentTab == 0
                                ? AppTheme.primaryGreen
                                : Colors.black54,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => currentTab = 1),
                          icon: Icon(
                            currentTab == 1 ? Icons.home_rounded : Icons.home_outlined,
                            size: 26,
                            color: currentTab == 1
                                ? AppTheme.primaryGreen
                                : Colors.black54,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => const RequestManageRidePage(),
                            ),
                          ),
                          icon: const Icon(
                            Icons.add,
                            size: 28,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const Opacity(
                      opacity: .75,
                      child: Text(
                        'Hillcrest Platte County',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.1,
                          color: AppTheme.logoText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }
}
