import 'package:flutter/material.dart';

import '../data/sample_rides.dart';
import '../models/ride_request.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/top_header.dart';
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

  List<RideRequest> get _filtered {
    if (searchTerm.trim().isEmpty) {
      return sampleRides;
    }
    final q = searchTerm.toLowerCase();
    return sampleRides
        .where(
          (ride) =>
              ride.participantName.toLowerCase().contains(q) ||
              ride.dateLabel.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopHeader(
              onSearchChanged: (value) => setState(() => searchTerm = value),
              hint: 'Search names & rides',
            ),
            Expanded(
              child: IndexedStack(
                index: currentTab,
                children: [
                  MapPage(rides: _filtered),
                  HomePage(rides: _filtered),
                  CalendarPage(rides: _filtered),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(vertical: 8),
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
                    Icons.place_outlined,
                    size: 30,
                    color: currentTab == 0
                        ? AppTheme.primaryGreen
                        : Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => currentTab = 1),
                  icon: Icon(
                    Icons.home_outlined,
                    size: 30,
                    color: currentTab == 1
                        ? AppTheme.primaryGreen
                        : Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const RequestManageRidePage(),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_outline, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Opacity(
              opacity: .75,
              child: Text(
                'Hillcrest Platte County',
                style: TextStyle(
                  fontSize: 11,
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
  }
}
