import 'package:flutter/material.dart';

import '../models/ride_request.dart';
import '../theme/app_theme.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.rides});

  final List<RideRequest> rides;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String selectedMonth = 'Mon';
  String selectedYear = '2026';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Weekly Rides',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _picker(
                value: selectedMonth,
                items: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                onChanged: (value) => setState(() => selectedMonth = value),
              ),
              const SizedBox(width: 10),
              _picker(
                value: selectedYear,
                items: const ['2025', '2026', '2027'],
                onChanged: (value) => setState(() => selectedYear = value),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppTheme.primaryGreen, thickness: 1.5),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: widget.rides.length,
              itemBuilder: (_, index) {
                final ride = widget.rides[index];
                return ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          ride.participantName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 21,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Icon(
                        ride.status == RideStatus.assigned
                            ? Icons.check_circle
                            : Icons.warning_amber_rounded,
                        color: ride.status == RideStatus.assigned
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text('${ride.pickupTime}\n${ride.dropoffTime}'),
                  ),
                  children: [
                    ListTile(
                      title: Text('Date: ${ride.dateLabel}'),
                      subtitle: Text(
                        'Driver: ${ride.driverName}\n'
                        'From: ${ride.fromAddress}\n'
                        'To: ${ride.toAddress}\n'
                        'Reason: ${ride.reason}',
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

  Widget _picker({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox.shrink(),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}
