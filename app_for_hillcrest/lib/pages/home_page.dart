import 'package:flutter/material.dart';

import '../models/ride_request.dart';
import '../theme/app_theme.dart';
import '../data/translations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.rides});

  final List<RideRequest> rides;

  @override
  Widget build(BuildContext context) {
    // Group rides by participant for a structured look
    final byName = <String, List<RideRequest>>{};
    for (final ride in rides) {
      byName.putIfAbsent(ride.participantName, () => []).add(ride);
    }
    final names = byName.keys.toList()..sort();

    return ValueListenableBuilder(
      valueListenable: TranslationService.currentLanguage,
      builder: (context, lang, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TranslationService.translate('welcome_back'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              TranslationService.translate('driver'),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            'lib/assets/hillcrest-logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Stats Row
                    Row(
                      children: [
                        _buildStatCard(
                          TranslationService.translate('total_rides'),
                          rides.length.toString(),
                          Icons.directions_car_filled_rounded,
                          Colors.blueAccent,
                        ),
                        const SizedBox(width: 16),
                        _buildStatCard(
                          TranslationService.translate('assigned'),
                          rides.where((r) => r.status == RideStatus.assigned).length.toString(),
                          Icons.check_circle_rounded,
                          AppTheme.primaryGreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      TranslationService.translate('upcoming_schedule'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Rides List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final name = names[index];
                    final rideList = byName[name]!;
                    return _buildParticipantGroup(name, rideList);
                  },
                  childCount: names.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantGroup(String name, List<RideRequest> rideList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryGreen.withOpacity(0.8),
              letterSpacing: 1.1,
            ),
          ),
        ),
        ...rideList.map((ride) => _buildRideCard(ride)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRideCard(RideRequest ride) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 6,
                color: ride.status == RideStatus.assigned
                    ? AppTheme.primaryGreen
                    : Colors.orangeAccent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 16, color: Colors.black45),
                              const SizedBox(width: 6),
                              Text(
                                ride.pickupTime,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (ride.status == RideStatus.assigned
                                      ? AppTheme.primaryGreen
                                      : Colors.orangeAccent)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              ride.status == RideStatus.assigned 
                                  ? TranslationService.translate('assigned') 
                                  : TranslationService.translate('pending'),
                              style: TextStyle(
                                color: ride.status == RideStatus.assigned
                                    ? AppTheme.primaryGreen
                                    : Colors.orange,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.circle, size: 8, color: AppTheme.primaryGreen),
                              Container(width: 1, height: 20, color: Colors.black12),
                              const Icon(Icons.location_on_rounded, size: 14, color: Colors.redAccent),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ride.fromAddress,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  ride.toAddress,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right_rounded, color: Colors.black26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
