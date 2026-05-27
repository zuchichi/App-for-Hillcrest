import 'package:flutter/material.dart';

import '../models/ride_request.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.rides});

  final List<RideRequest> rides;

  @override
  Widget build(BuildContext context) {
    final byName = <String, List<RideRequest>>{};
    for (final ride in rides) {
      byName.putIfAbsent(ride.participantName, () => []).add(ride);
    }
    final names = byName.keys.toList()..sort();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Current Rides',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          const Center(child: Icon(Icons.directions_car, size: 46)),
          const SizedBox(height: 14),
          const Divider(color: AppTheme.primaryGreen, thickness: 1.5),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: names.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, index) {
                final name = names[index];
                final rideList = byName[name]!;
                return ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(bottom: 8),
                  title: Text(
                    '$name  -  ${rideList.length} Rides',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  children: [
                    ...rideList.map(
                      (ride) => ListTile(
                        title: Text('${ride.dateLabel} - ${ride.pickupTime}'),
                        subtitle: Text(
                          '${ride.fromAddress} -> ${ride.toAddress}',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
