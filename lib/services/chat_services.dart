import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ChatServices extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<Message> messages = <Message>[].obs;

  void sendMessage(String text, String senderUserId, String reciverUserId,String bookingId) async {
    await firestore.collection('chats').add({
      'text': text,
      'timeStamp': FieldValue.serverTimestamp(),
      'senderUserId': senderUserId,
      'reciverUserId': reciverUserId,
      'bookingId': bookingId,
    });
  }

  void fetchMessages() {
    firestore
        .collection('chats')
        .orderBy('timeStamp', descending: true) 
        .snapshots()
        .listen((snapshot) {
      messages.assignAll(snapshot.docs.map((doc) => Message.fromFirestore(doc)));
    });
  }
   Stream<QuerySnapshot> fetchChatList() {
    return firestore.collection('chats').snapshots();
  }
}

class Message {
  final String text;
  final String senderUserId;
  final String reciverUserId;
  final Timestamp timeStamp;
  final String bookingId;


  Message({required this.text, required this.senderUserId, required this.reciverUserId, required this.timeStamp,required this.bookingId});

  factory Message.fromFirestore(DocumentSnapshot doc) {
    return Message(
      text: doc['text'],
      senderUserId: doc['senderUserId'],
      reciverUserId: doc['reciverUserId'],
      timeStamp: doc['timeStamp'] ?? Timestamp.now(),
      bookingId : doc['bookingId']
    );
  }
}
