import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import '../data/translations.dart';

class AppStatsPage extends StatelessWidget {
  const AppStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    TranslationService.translate('app_stats'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildStatStream(
                      collection: 'users',
                      label: 'Total Users',
                      icon: Icons.people_rounded,
                      color: Colors.blueAccent,
                    ),
                    _buildStatStream(
                      collection: 'rides',
                      label: 'Total Rides',
                      icon: Icons.directions_car_rounded,
                      color: AppTheme.primaryGreen,
                    ),
                    _buildStatStream(
                      collection: 'rides',
                      label: 'Assigned Rides',
                      icon: Icons.check_circle_rounded,
                      color: Colors.orangeAccent,
                      query: (ref) => ref.where('status', isEqualTo: 'assigned'),
                    ),
                    _buildStatStream(
                      collection: 'rides',
                      label: 'Pending Rides',
                      icon: Icons.access_time_filled_rounded,
                      color: Colors.redAccent,
                      query: (ref) => ref.where('status', isEqualTo: 'unassigned'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatStream({
    required String collection,
    required String label,
    required IconData icon,
    required Color color,
    Query Function(CollectionReference)? query,
  }) {
    Query ref = FirebaseFirestore.instance.collection(collection);
    if (query != null) ref = query(FirebaseFirestore.instance.collection(collection));

    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length.toString() ?? '...';
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                count,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }
}
