import 'package:flutter/material.dart';
import 'package:granth/models/book_model.dart';
import 'package:granth/services/book_service.dart';
import 'package:granth/services/firestore_service.dart';
import 'package:granth/pages/bookdetail.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final _firestoreService = FirestoreService();
  final _bookService = BookService();
  List<Book> _savedBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedBooks();
  }

  Future<void> _loadSavedBooks() async {
    final books = await _firestoreService.getSavedBooks();
    setState(() {
      _savedBooks = books;
      _isLoading = false;
    });
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Section label
            Container(
              color: Colors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: const Text(
                'YOUR LIBRARY',
                style: TextStyle(
                  fontFamily: 'JimNightshade',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF3F00),
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Body
            _isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  )
                : _savedBooks.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF3F00),
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.black, width: 3),
                                    bottom: BorderSide(
                                        color: Colors.black, width: 3),
                                    left: BorderSide(
                                        color: Colors.black, width: 3),
                                    right: BorderSide(
                                        color: Colors.black, width: 3),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(6, 6),
                                        blurRadius: 0),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.bookmark_border,
                                  size: 60,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'NOTHING SAVED YET.',
                                style: TextStyle(
                                  fontFamily: 'JimNightshade',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'go find something worth reading.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black45,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemCount: _savedBooks.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final book = _savedBooks[index];
                            return _savedBookTile(context, book);
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _savedBookTile(BuildContext context, Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(book: book),
          ),
        ).then((_) => _loadSavedBooks()); // refresh on return
      },
      child: Container(
        padding: const EdgeInsets.all(12),
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
                color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
          ],
        ),
        child: Row(
          children: [
            // Cover thumbnail
            Container(
              width: 60,
              height: 85,
              color: const Color(0xFFFF3F00),
              child: book.coverId != null
                  ? Image.network(
                      _bookService.getCoverUrl(book.coverId!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.auto_stories,
                        size: 28,
                        color: Colors.black,
                      ),
                    )
                  : const Icon(
                      Icons.auto_stories,
                      size: 28,
                      color: Colors.black,
                    ),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${book.author}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Arrow
            Container(
              padding: const EdgeInsets.all(6),
              color: Colors.black,
              child: const Icon(
                Icons.arrow_forward,
                color: Color(0xFFFF3F00),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}