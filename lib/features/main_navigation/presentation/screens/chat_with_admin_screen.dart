import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatWithAdminScreen extends StatelessWidget {
  const ChatWithAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Chat with Admin', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildIncomingMessage(
                  context,
                  avatarUrl: 'https://placehold.co/150/png',
                  name: 'Bonnie Green',
                  time: '11:46',
                  message: 'Hi Bonnie,\n\nYes, I\'m available tomorrow at 10 AM PST to discuss the launch. Let me know if that works for you.\n\nThanks!',
                  isSeen: true,
                ),
                const SizedBox(height: 24),
                _buildOutgoingMessage(
                  context,
                  avatarUrl: 'https://placehold.co/150/png',
                  name: 'Admin',
                  time: '11:46',
                  message: 'Okay, I just sent you an invite to a meeting next week. Please let me know if any of those times work, or if you\'d like me to propose an alternative.',
                ),
              ],
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildIncomingMessage(BuildContext context, {required String avatarUrl, required String name, required String time, required String message, bool isSeen = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 12, backgroundImage: NetworkImage(avatarUrl)),
            const SizedBox(width: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
            const SizedBox(width: 8),
            Text(time, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFF2F4F7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Text(message, style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4)),
        ),
        if (isSeen) ...[
          const SizedBox(height: 8),
          const Text('Seen', style: TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ],
    );
  }

  Widget _buildOutgoingMessage(BuildContext context, {required String avatarUrl, required String name, required String time, required String message}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
            const SizedBox(width: 8),
            Text(time, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(width: 8),
            CircleAvatar(radius: 12, backgroundImage: NetworkImage(avatarUrl)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF7A86C1), // Muted Purple-Blue
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
        ),
      ],
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black54),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Write message',
                  hintStyle: const TextStyle(color: Colors.black38),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: Colors.grey[300]!)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: Colors.grey[300]!)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send_outlined, color: Color(0xFF9C91B8)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
