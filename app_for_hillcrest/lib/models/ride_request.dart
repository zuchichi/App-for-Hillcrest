import 'package:google_maps_flutter/google_maps_flutter.dart';

enum RideStatus { assigned, unassigned }

class RideRequest {
  RideRequest({
    required this.id,
    required this.participantName,
    required this.dateLabel,
    required this.pickupTime,
    required this.dropoffTime,
    required this.fromAddress,
    required this.toAddress,
    required this.phone,
    required this.reason,
    required this.driverName,
    required this.driverPhone,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.status,
  });

  final String id;
  final String participantName;
  final String dateLabel;
  final String pickupTime;
  final String dropoffTime;
  final String fromAddress;
  final String toAddress;
  final String phone;
  final String reason;
  final String driverName;
  final String driverPhone;
  final LatLng departureLocation;
  final LatLng arrivalLocation;
  final RideStatus status;
}
