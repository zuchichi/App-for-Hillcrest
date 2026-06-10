import 'package:flutter/material.dart';

import '../models/ride_request.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/top_header.dart';
import '../data/translations.dart';
import '../services/ride_service.dart';
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
