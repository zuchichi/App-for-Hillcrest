import 'package:cloud_firestore/cloud_firestore.dart';

class BroadcastService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Send a broadcast message (can be global or targeted)
  Future<String?> sendBroadcast({
    required String title,
    required String message,
    required String senderUid,
    String? targetUid,
  }) async {
    try {
      await _db.collection('broadcasts').add({
        'title': title,
        'message': message,
        'senderUid': senderUid,
        'targetUid': targetUid, // null means global broadcast
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
