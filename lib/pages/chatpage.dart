import 'package:flutter/material.dart';
import 'package:granth/services/gemini_services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _geminiService = GeminiService();
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  // Each message: {'role': 'user'|'model', 'content': '...'}
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isLoading = true;
    });
    _inputController.clear();
    _scrollToBottom();

    final reply = await _geminiService.sendMessage(
      // pass history excluding the last user message (already added)
      _messages.sublist(0, _messages.length - 1),
      text,
    );

    setState(() {
      _messages.add({
        'role': 'model',
        'content': reply ?? 'Something went wrong. Try again.',
      });
      _isLoading = false;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0E8),
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(height: 3, color: Colors.black),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F0E8),
                border: Border(
                  top: BorderSide(color: Colors.black, width: 2),
                  bottom: BorderSide(color: Colors.black, width: 2),
                  left: BorderSide(color: Colors.black, width: 2),
                  right: BorderSide(color: Colors.black, width: 2),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(3, 3),
                      blurRadius: 0),
                ],
              ),
              child:
                  const Icon(Icons.arrow_back, color: Colors.black, size: 20),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'GRANTH',
          style: TextStyle(
            fontFamily: 'Comforter',
            fontWeight: FontWeight.bold,
            fontSize: 34,
            color: Colors.black,
            letterSpacing: 3,
          ),
        ),
      ),
      body: Column(
        children: [
          // Chat label
          Container(
            width: double.infinity,
            // color: Colors.black,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome,
                    color: Color(0xFFFF3F00), size: 16),
                SizedBox(width: 8),
                Text(
                  'ASK ANYTHING ABOUT BOOKS',
                  style: TextStyle(
                    fontFamily: 'JimNightshade',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? _emptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show typing indicator as last item
                      if (index == _messages.length && _isLoading) {
                        return _typingIndicator();
                      }
                      final msg = _messages[index];
                      final isUser = msg['role'] == 'user';
                      return _messageBubble(
                        content: msg['content']!,
                        isUser: isUser,
                      );
                    },
                  ),
          ),

          // Input area
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F0E8),
              border: Border(
                top: BorderSide(color: Colors.black, width: 3),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F0E8),
                      border: Border(
                        top: BorderSide(color: Colors.black, width: 2),
                        bottom: BorderSide(color: Colors.black, width: 2),
                        left: BorderSide(color: Colors.black, width: 2),
                        right: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    child: TextField(
                      controller: _inputController,
                      onSubmitted: (_) => _sendMessage(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Ask for a recommendation...',
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF5F0E8),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        top: BorderSide(color: Colors.black, width: 2),
                        bottom: BorderSide(color: Colors.black, width: 2),
                        left: BorderSide(color: Colors.black, width: 2),
                        right: BorderSide(color: Colors.black, width: 2),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFFFF3F00),
                            offset: Offset(3, 3),
                            blurRadius: 0),
                      ],
                    ),
                    child: const Icon(Icons.send,
                        color: Color(0xFFFF3F00), size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBubble({required String content, required bool isUser}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              // color: Colors.black,
              child: const Icon(Icons.auto_awesome,
                  color: Color(0xFFFF3F00), size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser ? Colors.black : const Color(0xFFF5F0E8),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? const Color(0xFFFF3F00)
                        : Colors.black,
                    offset: const Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: isUser ? const Color(0xFFF5F0E8) : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              color: const Color(0xFFFF3F00),
              child: const Icon(Icons.person, color: Colors.black, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _typingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            color: Colors.black,
            child: const Icon(Icons.auto_awesome,
                color: Color(0xFFFF3F00), size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F0E8),
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Colors.black, width: 2),
                left: BorderSide(color: Colors.black, width: 2),
                right: BorderSide(color: Colors.black, width: 2),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    offset: Offset(3, 3),
                    blurRadius: 0),
              ],
            ),
            child: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  color: Colors.black, strokeWidth: 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFFF3F00),
                border: Border(
                  top: BorderSide(color: Colors.black, width: 3),
                  bottom: BorderSide(color: Colors.black, width: 3),
                  left: BorderSide(color: Colors.black, width: 3),
                  right: BorderSide(color: Colors.black, width: 3),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(6, 6),
                      blurRadius: 0),
                ],
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 48, color: Colors.black),
            ),
            const SizedBox(height: 24),
            const Text(
              'YOUR BOOK ASSISTANT.',
              style: TextStyle(
                fontFamily: 'JimNightshade',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ask for recommendations,\nsummaries, or anything books.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black45,
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}