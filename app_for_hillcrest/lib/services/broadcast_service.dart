import 'package:cloud_firestore/cloud_firestore.dart';

class BroadcastService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Send a broadcast message
  Future<String?> sendBroadcast({
    required String title,
    required String message,
    required String senderUid,
  }) async {
    try {
      await _db.collection('broadcasts').add({
        'title': title,
        'message': message,
        'senderUid': senderUid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Stream of latest broadcasts
  Stream<QuerySnapshot> get latestBroadcasts {
    return _db
        .collection('broadcasts')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }
}
