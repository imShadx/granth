import 'package:flutter/material.dart';
import 'package:granth/models/book_model.dart';
import 'package:granth/services/book_service.dart';
import 'package:granth/services/firestore_service.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final _bookService = BookService();
  final _firestoreService = FirestoreService();
  String? _summary;
  bool _loadingSummary = true;
  bool _isSaved = false;
  bool _savingInProgress = false;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
    _checkIfSaved();
  }

  Future<void> _fetchSummary() async {
    final summary = await _bookService.getBookSummary(widget.book.id);
    setState(() {
      _summary = summary;
      _loadingSummary = false;
    });
  }

  Future<void> _checkIfSaved() async {
    final saved = await _firestoreService.isBookSaved(widget.book.id);
    setState(() => _isSaved = saved);
  }

  Future<void> _toggleSave() async {
    setState(() => _savingInProgress = true);
    if (_isSaved) {
      await _firestoreService.unsaveBook(widget.book.id);
    } else {
      await _firestoreService.saveBook(widget.book);
    }
    setState(() {
      _isSaved = !_isSaved;
      _savingInProgress = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSaved ? 'SAVED TO LIBRARY +' : 'REMOVED FROM LIBRARY'),
        backgroundColor: Colors.black,
      ),
    );
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
              child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Book cover
            Center(
              child: Container(
                width: 180,
                height: 260,
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
                        offset: Offset(8, 8),
                        blurRadius: 0),
                  ],
                ),
                child: widget.book.coverId != null
                    ? Image.network(
                        _bookService.getCoverUrl(widget.book.coverId!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.auto_stories,
                          size: 90,
                          color: Colors.black,
                        ),
                      )
                    : const Icon(
                        Icons.auto_stories,
                        size: 90,
                        color: Colors.black,
                      ),
              ),
            ),

            const SizedBox(height: 28),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.book.title.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'JimNightshade',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Author row
            Row(
              children: [
                Text(
                  'by ${widget.book.author}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Container(height: 3, color: Colors.black),
            const SizedBox(height: 20),

            // Summary label
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'SUMMARY',
                style: TextStyle(
                  fontFamily: 'JimNightshade',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
                      offset: Offset(4, 4),
                      blurRadius: 0),
                ],
              ),
              child: _loadingSummary
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    )
                  : Text(
                      _summary ?? 'No summary available for this book.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.7,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                // Read button (placeholder for now)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: navigate to reader page
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                              offset: Offset(5, 5),
                              blurRadius: 0),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book,
                              color: Color(0xFFFF3F00), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'READ →',
                            style: TextStyle(
                              fontFamily: 'JimNightshade',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF5F0E8),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Save button — live state
                Expanded(
                  child: GestureDetector(
                    onTap: _savingInProgress ? null : _toggleSave,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _isSaved
                            ? Colors.black
                            : const Color(0xFFF5F0E8),
                        border: const Border(
                          top: BorderSide(color: Colors.black, width: 2),
                          bottom: BorderSide(color: Colors.black, width: 2),
                          left: BorderSide(color: Colors.black, width: 2),
                          right: BorderSide(color: Colors.black, width: 2),
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(5, 5),
                              blurRadius: 0),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _savingInProgress
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      color: Colors.black, strokeWidth: 2),
                                )
                              : Icon(
                                  _isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: _isSaved
                                      ? const Color(0xFFFF3F00)
                                      : Colors.black,
                                  size: 20,
                                ),
                          const SizedBox(width: 8),
                          Text(
                            _isSaved ? 'SAVED ✓' : 'SAVE +',
                            style: TextStyle(
                              fontFamily: 'JimNightshade',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _isSaved
                                  ? const Color(0xFFF5F0E8)
                                  : Colors.black,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}