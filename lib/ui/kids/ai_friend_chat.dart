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
    if (_controller.text.isEmpty) return;
    
    setState(() {
      _messages.add({'role': 'user', 'content': _controller.text});
      _controller.clear();
    });

    // Simple AI response simulation
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'role': 'ai', 
            'content': 'That sounds like a great plan! Completing your Duolingo lesson would get you closer to your goal. 🚀'
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      color: isAI ? Colors.grey[100] : const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomLeft: isAI ? const Radius.circular(0) : const Radius.circular(16),
                        bottomRight: isAI ? const Radius.circular(16) : const Radius.circular(0),
                      ),
                    ),
                    child: Text(
                      msg['content']!,
                      style: TextStyle(color: isAI ? Colors.black : Colors.white),
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
    );
  }
}
