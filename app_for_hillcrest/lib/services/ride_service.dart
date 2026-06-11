import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ride_request.dart';

class RideService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of all rides
  Stream<List<RideRequest>> get ridesStream {
    return _db.collection('rides').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return RideRequest.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Request a ride
  Future<void> requestRide(RideRequest ride) async {
    final docRef = _db.collection('rides').doc();
    await docRef.set(ride.toMap());
    
    // Also add to user's requestedRides list if applicable
    if (ride.requesterUid != null) {
      await _db.collection('users').doc(ride.requesterUid).update({
        'requestedRides': FieldValue.arrayUnion([ride.toMap()])
      });
    }
  }

  // Accept a ride
  Future<void> acceptRide(String rideId, String driverName, String driverPhone) async {
    final batch = _db.batch();
    
    final rideRef = _db.collection('rides').doc(rideId);
    batch.update(rideRef, {
      'status': 'assigned',
      'driverName': driverName,
      'driverPhone': driverPhone,
    });

    final statsRef = _db.collection('stats').doc('global');
    batch.set(statsRef, {
      'totalRidesGiven': FieldValue.increment(1),
    }, SetOptions(merge: true));

    await batch.commit();
  }
}
