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
    this.driverName,
    this.driverPhone,
    this.departureLocation,
    this.arrivalLocation,
    required this.status,
    this.requesterUid,
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
  final String? driverName;
  final String? driverPhone;
  final LatLng? departureLocation;
  final LatLng? arrivalLocation;
  final RideStatus status;
  final String? requesterUid;

  Map<String, dynamic> toMap() {
    return {
      'participantName': participantName,
      'dateLabel': dateLabel,
      'pickupTime': pickupTime,
      'dropoffTime': dropoffTime,
      'fromAddress': fromAddress,
      'toAddress': toAddress,
      'phone': phone,
      'reason': reason,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'departureLat': departureLocation?.latitude,
      'departureLng': departureLocation?.longitude,
      'arrivalLat': arrivalLocation?.latitude,
      'arrivalLng': arrivalLocation?.longitude,
      'status': status == RideStatus.assigned ? 'assigned' : 'unassigned',
      'requesterUid': requesterUid,
    };
  }

  factory RideRequest.fromMap(String id, Map<String, dynamic> map) {
    return RideRequest(
      id: id,
      participantName: map['participantName'] ?? '',
      dateLabel: map['dateLabel'] ?? '',
      pickupTime: map['pickupTime'] ?? '',
      dropoffTime: map['dropoffTime'] ?? '',
      fromAddress: map['fromAddress'] ?? '',
      toAddress: map['toAddress'] ?? '',
      phone: map['phone'] ?? '',
      reason: map['reason'] ?? '',
      driverName: map['driverName'],
      driverPhone: map['driverPhone'],
      departureLocation: map['departureLat'] != null 
          ? LatLng(map['departureLat'], map['departureLng']) 
          : null,
      arrivalLocation: map['arrivalLat'] != null 
          ? LatLng(map['arrivalLat'], map['arrivalLng']) 
          : null,
      status: map['status'] == 'assigned' ? RideStatus.assigned : RideStatus.unassigned,
      requesterUid: map['requesterUid'],
    );
  }
}
