import 'package:flutter/material.dart';

class BookDetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String rating;

  // TODO: when API is connected, add:
  // final String coverUrl;
  // final String summary;
  // final String bookId;

  const BookDetailPage({
    super.key,
    required this.title,
    required this.author,
    required this.rating,
  });

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
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              ),
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
            // TODO: replace inner content with CachedNetworkImage(url: coverUrl)
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
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_stories,
                  size: 90,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Title block
            Container(
              // color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                title.toUpperCase(),
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

            // Author + rating row
            Row(
              children: [
                Text(
                  'by $author',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                Container(
                  color: const Color(0xFFFF3F00),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: Text(
                    '★ $rating',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Thick divider
            Container(height: 3, color: Colors.black),

            const SizedBox(height: 20),

            // Summary section
            Container(
              // color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: const Text(
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
                    blurRadius: 0,
                  ),
                ],
              ),
              // TODO: replace placeholder with summary from API response
              child: const Text(
                'Summary will appear here once connected to the book API.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.7,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                // Read button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: navigate to reader page with book content from API
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
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book,
                            color: Color(0xFFFF3F00),
                            size: 20,
                          ),
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

                // Save button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: save book to user's library via API / local DB
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                            offset: Offset(5, 5),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            color: Colors.black,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'SAVE +',
                            style: TextStyle(
                              fontFamily: 'JimNightshade',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
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