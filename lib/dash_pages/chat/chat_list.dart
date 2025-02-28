import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:urbanclap_servicemen/services/chat_services.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ChatServices _chatServices = Get.put(ChatServices());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatServices.fetchChatList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(child: Text("No Chats Available"));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index];
              // var lastMessage = chat['lastMessage'] ?? "No messages yet";
              // var chatPartner = chat['chatPartner']; // Replace with actual logic to fetch chat partner

              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                // title: Text(chatPartner, style: TextStyle(fontWeight: FontWeight.bold)),
                // subtitle: Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () {
                  // Navigate to chat screen with selected user
                },
              );
            },
          );
        },
      ),
    );
  }
}