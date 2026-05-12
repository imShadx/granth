import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:granth/pages/bookdetail.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  final List<Map<String, String>> _allBooks = const [
    {'title': 'The Hobbit', 'author': 'J.R.R. Tolkien', 'rating': '4.9'},
    {'title': 'Brave New World', 'author': 'Aldous Huxley', 'rating': '4.6'},
    {'title': 'Crime & Punishment', 'author': 'Dostoevsky', 'rating': '4.7'},
    {'title': 'The Alchemist', 'author': 'Paulo Coelho', 'rating': '4.5'},
    {'title': 'Moby Dick', 'author': 'Herman Melville', 'rating': '4.4'},
    {'title': 'Jane Eyre', 'author': 'Charlotte Brontë', 'rating': '4.7'},
    {'title': 'The Odyssey', 'author': 'Homer', 'rating': '4.6'},
    {'title': 'Don Quixote', 'author': 'Cervantes', 'rating': '4.5'},
    {'title': 'Anna Karenina', 'author': 'Leo Tolstoy', 'rating': '4.8'},
    {'title': 'Frankenstein', 'author': 'Mary Shelley', 'rating': '4.6'},
    {'title': 'The Trial', 'author': 'Franz Kafka', 'rating': '4.5'},
    {'title': 'Middlemarch', 'author': 'George Eliot', 'rating': '4.6'},
  ];

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
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 36, minHeight: 36),
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
              _sectionLabel("TODAY'S PICKS"),
              const SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _bookCard(context, 'Dune', 'Frank Herbert', '4.8'),
                    const SizedBox(width: 12),
                    _bookCard(context, '1984', 'George Orwell', '4.7'),
                    const SizedBox(width: 12),
                    _bookCard(
                        context, 'Kafka on the Shore', 'Haruki Murakami', '4.6'),
                    const SizedBox(width: 12),
                    _bookCard(context, 'Dracula', 'Bram Stoker', '4.6'),
                    const SizedBox(width: 12),
                    _bookCard(context, 'Odyssey', 'Homer', '4.6'),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Search bar
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
                  onSubmitted: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Searching for "$value"...'),
                        backgroundColor: Colors.black,
                      ),
                    );
                  },
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

              _sectionLabel('BROWSE ALL'),
              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _allBooks.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6,
                ),
                itemBuilder: (context, index) {
                  final book = _allBooks[index];
                  return _smallBookCard(
                    context,
                    book['title']!,
                    book['author']!,
                    book['rating']!,
                  );
                },
              ),

              const SizedBox(height: 28),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
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
      // color: Colors.black,
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

  void _openBookDetail(
      BuildContext context, String title, String author, String rating) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailPage(
          title: title,
          author: author,
          rating: rating,
        ),
      ),
    );
  }

  Widget _bookCard(
      BuildContext context, String title, String author, String rating) {
    return GestureDetector(
      onTap: () => _openBookDetail(context, title, author, rating),
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
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 155,
              width: double.infinity,
              color: const Color(0xFFFF3F00),
              child: const Icon(
                Icons.auto_stories,
                size: 50,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
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
              author,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Container(
              color: Colors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: Text(
                '★ $rating',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFFFF3F00),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallBookCard(
      BuildContext context, String title, String author, String rating) {
    return GestureDetector(
      onTap: () => _openBookDetail(context, title, author, rating),
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
            BoxShadow(
              color: Colors.black,
              offset: Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFFF3F00),
                child: const Icon(
                  Icons.auto_stories,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
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
              author,
              style: const TextStyle(fontSize: 8, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Container(
              color: Colors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              child: Text(
                '★ $rating',
                style: const TextStyle(
                  fontSize: 8,
                  color: Color(0xFFFF3F00),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}