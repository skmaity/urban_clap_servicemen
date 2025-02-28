import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbanclap_servicemen/services/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String reciverUserId;
  final String bookingId;
  const ChatPage({super.key,required this.reciverUserId,required this.bookingId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatServices _chatServices = Get.put(ChatServices());
  final TextEditingController _messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _chatServices.fetchMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(

        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              shrinkWrap: true,
                  reverse: true,
                  itemCount: _chatServices.messages.length, 
                  itemBuilder: (context, index) {
                    final message = _chatServices.messages[index];
                    return message.bookingId == widget.bookingId ? Align(
                      alignment: message.senderUserId == currentUser!.uid
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: message.senderUserId == currentUser!.uid
                              ? Colors.blue
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ), 
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: message.senderUserId == currentUser!.uid
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ) : SizedBox.shrink();
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      _chatServices.sendMessage(_messageController.text, currentUser!.uid, widget.reciverUserId,widget.bookingId); // Replace with actual IDs
                      _messageController.clear();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}