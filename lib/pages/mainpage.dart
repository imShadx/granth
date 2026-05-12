import 'package:flutter/material.dart';
import 'homepage.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  final List<Map<String, String>> _allBooks = const [
    {'title': 'The Hobbit', 'author': 'J.R.R. Tolkien', 'rating': '⭐ 4.9'},
    {'title': 'Brave New World', 'author': 'Aldous Huxley', 'rating': '⭐ 4.6'},
    {'title': 'Crime & Punishment', 'author': 'Dostoevsky', 'rating': '⭐ 4.7'},
    {'title': 'The Alchemist', 'author': 'Paulo Coelho', 'rating': '⭐ 4.5'},
    {'title': 'Moby Dick', 'author': 'Herman Melville', 'rating': '⭐ 4.4'},
    {'title': 'Jane Eyre', 'author': 'Charlotte Brontë', 'rating': '⭐ 4.7'},
    {'title': 'The Odyssey', 'author': 'Homer', 'rating': '⭐ 4.6'},
    {'title': 'Don Quixote', 'author': 'Cervantes', 'rating': '⭐ 4.5'},
    {'title': 'Anna Karenina', 'author': 'Leo Tolstoy', 'rating': '⭐ 4.8'},
    {'title': 'Frankenstein', 'author': 'Mary Shelley', 'rating': '⭐ 4.6'},
    {'title': 'The Trial', 'author': 'Franz Kafka', 'rating': '⭐ 4.5'},
    {'title': 'Middlemarch', 'author': 'George Eliot', 'rating': '⭐ 4.6'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFCF99),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF92140C).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 20),
              onPressed: () {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(
                    0,
                    120,
                    0,
                    0,
                  ), // drops down from top left
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: const Color(0xFFFFCF99),
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
                          Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: Color(0xFF92140C),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Back to Home',
                            style: TextStyle(
                              fontFamily: 'JimNightshade',
                              fontSize: 16,
                              color: Color(0xFF92140C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Granth',
          style: TextStyle(
            fontFamily: 'Comforter',
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF92140C).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ),
          ),
        ],
        backgroundColor: const Color(0xFF92140C).withOpacity(0.5),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // recommendations row
              const Text(
                "Today's Recommendations",
                style: TextStyle(
                  fontFamily: 'JimNightshade',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _bookCard('Dune', 'Frank Herbert', '⭐ 4.8'),
                    const SizedBox(width: 12),
                    _bookCard('1984', 'George Orwell', '⭐ 4.7'),
                    const SizedBox(width: 12),
                    _bookCard('Kafka on the Shore', 'Haruki Murakami', '⭐ 4.6'),
                    const SizedBox(width: 12),
                    _bookCard('Dracula', 'Bram Stoker', '⭐ 4.6'),
                    const SizedBox(width: 12),
                    _bookCard('Odyssey', 'Homer', '⭐ 4.6'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // search bar
              TextField(
                onSubmitted: (value) {
                  // value is whatever the user typed
                  print(value); // just to test for now
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Searching for "$value"...')),
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search books...',
                  hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.black38),
                  filled: true,
                  fillColor: const Color(0xFF92140C).withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // browse section
              const Text(
                'Browse',
                style: TextStyle(
                  fontFamily: 'JimNightshade',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 3 column grid
              GridView.builder(
                shrinkWrap:
                    true, // important — lets GridView sit inside SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // parent handles scrolling
                itemCount: _allBooks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6, // controls card height vs width
                ),
                itemBuilder: (context, index) {
                  final book = _allBooks[index];
                  return _smallBookCard(
                    book['title']!,
                    book['author']!,
                    book['rating']!,
                  );
                },
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: const Text(
                    'Search to explore more....',
                    style: TextStyle(
                      fontFamily: 'JimNightshade',
                      fontSize: 16,
                      color: Colors.black38,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookCard(String title, String author, String rating) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF92140C).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF92140C).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF92140C).withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_stories,
              size: 50,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            author,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(rating, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _smallBookCard(String title, String author, String rating) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF92140C).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF92140C).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF92140C).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_stories,
                size: 30,
                color: Colors.white54,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            author,
            style: const TextStyle(fontSize: 9, color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(rating, style: const TextStyle(fontSize: 9)),
        ],
      ),
    );
  }
}
