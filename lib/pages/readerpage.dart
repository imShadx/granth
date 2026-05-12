import 'package:flutter/material.dart';
import 'package:granth/services/firestore_service.dart';

class ReaderPage extends StatefulWidget {
  final String title;
  final String bookText;

  const ReaderPage({super.key, required this.title, required this.bookText});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  double _fontSize = 16;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    FirestoreService().logReadingActivity();
  }

  // Gutenberg books have a lot of header junk before the actual text
  // This strips everything before "*** START OF" marker
  String get _cleanText {
    const startMarker = '*** START OF';
    const endMarker = '*** END OF';
    final text = widget.bookText;

    int start = text.indexOf(startMarker);
    if (start != -1) {
      // skip past the marker line itself
      start = text.indexOf('\n', start) + 1;
    } else {
      start = 0;
    }

    int end = text.indexOf(endMarker);
    if (end == -1) end = text.length;

    return text.substring(start, end).trim();
  }

  // Splits the raw text into paragraphs by splitting on double newlines
  // This turns a wall of text into readable chunks
  List<String> get _paragraphs {
    return _cleanText
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.replaceAll('\n', ' ').trim())
        .where((p) => p.isNotEmpty)
        .toList();
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
        title: Text(
          widget.title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'JimNightshade',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
            letterSpacing: 2,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        // Tap anywhere on appbar to toggle the font controls
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => setState(() => _showControls = !_showControls),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                child: const Icon(Icons.text_fields,
                    color: Color(0xFFFF3F00), size: 20),
              ),
            ),
          ),
        ],
      ),

      // Font size controls — only shown when _showControls is true
      bottomNavigationBar: _showControls
          ? Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F0E8),
                border: Border(
                  top: BorderSide(color: Colors.black, width: 3),
                ),
              ),
              child: Row(
                children: [
                  // Decrease font
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_fontSize > 12) {
                          setState(() => _fontSize -= 1);
                        }
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'A−',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Current font size display
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${_fontSize.toInt()}px',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  // Increase font
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_fontSize < 24) {
                          setState(() => _fontSize += 1);
                        }
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'A+',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        // Each paragraph is its own list item
        // This is way better than one giant Text widget because:
        // 1. Flutter only renders visible paragraphs (performance)
        // 2. Each paragraph has breathing room
        // 3. Chapter headings get special treatment
        itemCount: _paragraphs.length,
        itemBuilder: (context, index) {
          final paragraph = _paragraphs[index];

          // Detect chapter headings — usually short ALL CAPS lines
          final isHeading = paragraph.length < 60 &&
              paragraph == paragraph.toUpperCase() &&
              paragraph.isNotEmpty;

          if (isHeading) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    child: Text(
                      paragraph,
                      style: TextStyle(
                        fontFamily: 'JimNightshade',
                        fontSize: _fontSize + 2,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF3F00),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(height: 2, color: Colors.black),
                ],
              ),
            );
          }

          // Regular paragraph
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              paragraph,
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.8, // line height — makes it readable not cramped
                color: Colors.black87,
                letterSpacing: 0.2,
              ),
            ),
          );
        },
      ),
    );
  }
}