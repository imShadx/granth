import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:granth/pages/bookdetail.dart';
import 'package:granth/models/book_model.dart';
import 'package:granth/services/book_service.dart';
import 'package:granth/pages/savedpage.dart';
import 'package:granth/pages/profilepage.dart';
import 'package:granth/pages/chatpage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _bookService = BookService();
  List<Book> _recommendations = [];
  List<Book> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    final books = await _bookService.getRecommendations();
    setState(() {
      _recommendations = books;
      _isLoading = false;
    });
  }

  Future<void> _searchBooks(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isSearching = true);
    final books = await _bookService.searchBooks(query);
    setState(() {
      _searchResults = books;
      _isSearching = false;
    });
  }

  void _openBookDetail(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailPage(book: book)),
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
            onTap: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(0, 100, 0, 0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                color: const Color(0xFFF5F0E8),
                items: [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedPage(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.bookmark, size: 18, color: Colors.black),
                        SizedBox(width: 10),
                        Text(
                          'SAVED',
                          style: TextStyle(
                            fontFamily: 'JimNightshade',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatPage(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 18, color: Colors.black),
                        SizedBox(width: 10),
                        Text(
                          'ASK AI',
                          style: TextStyle(
                            fontFamily: 'JimNightshade',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  PopupMenuItem(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, size: 18, color: Colors.black),
                        SizedBox(width: 10),
                        Text(
                          'BACK TO HOME',
                          style: TextStyle(
                            fontFamily: 'JimNightshade',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
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
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(Icons.menu, color: Colors.black, size: 20),
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFF3F00),
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
                    blurRadius: 0,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.black, size: 20),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // --- TODAY'S PICKS ---
              _sectionLabel("TODAY'S PICKS"),
              const SizedBox(height: 12),

              _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _recommendations
                            .map(
                              (book) => Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: _bookCard(context, book),
                              ),
                            )
                            .toList(),
                      ),
                    ),

              const SizedBox(height: 28),

              // --- SEARCH BAR ---
              Container(
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
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: TextField(
                  onSubmitted: _searchBooks,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'SEARCH BOOKS...',
                    hintStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: 13,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    filled: true,
                    fillColor: Color(0xFFF5F0E8),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // --- BROWSE / SEARCH RESULTS ---
              _sectionLabel(
                _searchResults.isNotEmpty ? 'RESULTS' : 'BROWSE ALL',
              ),
              const SizedBox(height: 12),

              _isSearching
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _searchResults.isNotEmpty
                          ? _searchResults.length
                          : _recommendations.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.6,
                          ),
                      itemBuilder: (context, index) {
                        final book = _searchResults.isNotEmpty
                            ? _searchResults[index]
                            : _recommendations[index];
                        return _smallBookCard(context, book);
                      },
                    ),

              const SizedBox(height: 28),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Text(
                    'SEARCH TO EXPLORE MORE →',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'JimNightshade',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _bookCard(BuildContext context, Book book) {
    return GestureDetector(
      onTap: () => _openBookDetail(context, book),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F0E8),
          border: Border(
            top: BorderSide(color: Colors.black, width: 2),
            bottom: BorderSide(color: Colors.black, width: 2),
            left: BorderSide(color: Colors.black, width: 2),
            right: BorderSide(color: Colors.black, width: 2),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 155,
              width: double.infinity,
              color: const Color(0xFFFF3F00),
              child: book.coverId != null
                  ? Image.network(
                      _bookService.getCoverUrl(book.coverId!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.auto_stories,
                        size: 50,
                        color: Colors.black,
                      ),
                    )
                  : const Icon(
                      Icons.auto_stories,
                      size: 50,
                      color: Colors.black,
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              book.author,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallBookCard(BuildContext context, Book book) {
    return GestureDetector(
      onTap: () => _openBookDetail(context, book),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F0E8),
          border: Border(
            top: BorderSide(color: Colors.black, width: 2),
            bottom: BorderSide(color: Colors.black, width: 2),
            left: BorderSide(color: Colors.black, width: 2),
            right: BorderSide(color: Colors.black, width: 2),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
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
            ),
            const SizedBox(height: 5),
            Text(
              book.title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 10,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              book.author,
              style: const TextStyle(fontSize: 8, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
