import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/state_providers.dart';

class AIFriendChat extends ConsumerStatefulWidget {
  const AIFriendChat({super.key});

  @override
  ConsumerState<AIFriendChat> createState() => _AIFriendChatState();
}

class _AIFriendChatState extends ConsumerState<AIFriendChat> {
  final List<Map<String, String>> _messages = [
    {'role': 'ai', 'content': 'Hey there! I\'m Safini, your AI friend. Ready to earn some Time Coins today?'}
  ];
  final _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _controller.clear();
    });

    // Simple AI response logic
    String aiResponse = "That's interesting! Tell me more.";
    final lowerText = text.toLowerCase();
    
    if (lowerText.contains('hi') || lowerText.contains('hello')) {
      aiResponse = "Hi there! I'm Safini. Ready to earn some coins?";
    } else if (lowerText.contains('coin') || lowerText.contains('earn')) {
      aiResponse = "You can earn coins by completing missions like Duolingo or taking steps! Check the Mission Feed.";
    } else if (lowerText.contains('roblox') || lowerText.contains('game')) {
      aiResponse = "Roblox is a great reward! You need 50 coins to unlock 30 minutes. You can do it!";
    } else if (lowerText.contains('how')) {
      aiResponse = "Just finish your tasks, submit proof, and once your parent approves, you get coins!";
    } else if (lowerText.contains('duolingo')) {
      aiResponse = "Duolingo is awesome for learning! Finishing a lesson gets you closer to your goal. 🚀";
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'role': 'ai', 
            'content': aiResponse
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE0E0FF),
                  child: Icon(Icons.face, color: Color(0xFF6C63FF)),
                ),
                const SizedBox(width: 12),
                Text('Chat with Safini', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isAI = msg['role'] == 'ai';
                  return Align(
                    alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isAI ? const Color(0xFFF0F0FF) : const Color(0xFF6C63FF),
                        borderRadius: BorderRadius.circular(16).copyWith(
                          bottomLeft: isAI ? const Radius.circular(0) : const Radius.circular(16),
                          bottomRight: isAI ? const Radius.circular(16) : const Radius.circular(0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        msg['content']!,
                        style: TextStyle(
                          color: isAI ? const Color(0xFF212121) : Colors.white,
                          fontWeight: isAI ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask Safini something...',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF6C63FF),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
