// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class TeacherChatService {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Local mock for offline testing
  final Map<String, List<Map<String, dynamic>>> _localChats = {};
  final Map<String, StreamController<List<Map<String, dynamic>>>> _controllers =
      {};

  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    // Uncomment for Firestore in production
    /*
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    */
    // Local mock stream
    _localChats.putIfAbsent(chatId, () => []);
    _controllers.putIfAbsent(
        chatId, () => StreamController<List<Map<String, dynamic>>>.broadcast());
    if (_controllers[chatId] == null) {
      return const Stream.empty();
    }
    return _controllers[chatId]!.stream;
  }

  Future<void> sendMessage(
      String chatId, String senderId, String senderName, String text) async {
    // Uncomment for Firestore in production
    /*
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
    */
    // Local mock for offline
    final msg = {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
    };
    _localChats.putIfAbsent(chatId, () => []);
    _localChats[chatId]?.add(msg);
    _controllers.putIfAbsent(
        chatId, () => StreamController<List<Map<String, dynamic>>>.broadcast());
    if (_controllers[chatId] != null && _localChats[chatId] != null) {
      _controllers[chatId]!
          .add(List<Map<String, dynamic>>.from(_localChats[chatId]!));
    }
  }
}
