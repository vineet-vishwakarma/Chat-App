import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:chat_app/widgets/text_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  const ChatScreen({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final AuthController _authController = AuthController();
  final ChatController _chatController = ChatController();

  // Focus
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // ScrollController
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatController.sendMessage(
          widget.receiverId, _messageController.text);

      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(widget.receiverEmail),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Column(
            children: [
              Expanded(child: _buildMessageList()),

              // Text Input
              _buildUserInput(),
            ],
          ),
          GestureDetector(
            onTap: scrollDown,
            child: Container(
              margin: const EdgeInsets.only(bottom: 100, right: 5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.keyboard_double_arrow_down_sharp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authController.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatController.getMessages(widget.receiverId, senderId),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((doc) => _buildMessageListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser =
        data['senderId'] == _authController.getCurrentUser()!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0, top: 5),
      child: Row(
        children: [
          Expanded(
            child: TextInputField(
                focusNode: focusNode,
                controller: _messageController,
                labelText: 'Write a message'),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_forward_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
