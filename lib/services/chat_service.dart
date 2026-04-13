import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns a stream of messages ordered by timestamp ascending (oldest first).
  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  /// Sends a message to the Firestore 'messages' collection.
  /// Now includes senderUid and senderPhotoUrl for auth-based matching.
  Future<void> sendMessage({
    required String text,
    required String sender,
    required String senderUid,
    String? senderPhotoUrl,
  }) async {
    await _firestore.collection('messages').add({
      'text': text,
      'sender': sender,
      'senderUid': senderUid,
      'senderPhotoUrl': senderPhotoUrl ?? '',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Deletes a message by its document ID.
  Future<void> deleteMessage(String messageId) async {
    await _firestore.collection('messages').doc(messageId).delete();
  }
}
