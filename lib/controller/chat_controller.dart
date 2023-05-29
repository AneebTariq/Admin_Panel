import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../models/chat_model.dart';

class FirebaseDbClient {
  final _chatDb = FirebaseDatabase.instance.reference().child('chat');

  Stream<List<ChatMsgModel>> getOrderChat(String requestId) {
    bool responseReceived = false;
    final subscription =
    _chatDb.child(_getOrderRef(requestId)).onValue.map((event) {
      responseReceived = true;
      final Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
      List<ChatMsgModel>? chat = data?.values
          .map((e) => ChatMsgModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      chat?.sort(
              (msg1, msg2) => msg1.dateAndTime!.compareTo(msg2.dateAndTime!));
      return chat ?? [];
    }).timeout(Duration(seconds: 10), onTimeout: (sink) {
      if (!responseReceived) {
        throw (TimeoutException('No Stream event'));
      }
    });
    return subscription;
  }

  Future<void> sendMessageOrderChat(String requestId, ChatMsgModel msg) async {
    _chatDb.child(_getOrderRef(requestId)).push().set(msg.toJson());
  }

  // Future sendMessage(String message,String name,String token) async {
  //   var resp = await post("https://fcm.googleapis.com/fcm/send",  {
  //     "notification": {"body": message, "title": 'chat messages'},
  //     "priority": 'high',
  //     "data": {
  //       "click_action": 'FLUTTER_NOTIFICATION_CLICK',
  //       'id': '1',
  //       'message': 'Chat Messages',
  //     },
  //     'to': token,
  //   },
  //       headers: {
  //         "content-type": 'application/json',
  //         "Authorization": 'key=${Constants.firebaseServerKey}',
  //       }
  //   );
  //   print("resp " + resp.toString());
  // }

  String _getOrderRef(String requestId) => 'Chat_No_$requestId';
}