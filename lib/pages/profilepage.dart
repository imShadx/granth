import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:granth/services/auth_service.dart';
import 'package:granth/services/firestore_service.dart';
import 'package:granth/pages/homepage.dart';
import 'package:granth/widgets/reading_graph.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _user = FirebaseAuth.instance.currentUser;
  final _firestoreService = FirestoreService();
  final _usernameController = TextEditingController();

  bool _editingUsername = false;
  bool _savingUsername = false;
  int _savedBooksCount = 0;
  bool _loadingCount = true;

  @override
  void initState() {
    super.initState();
    _usernameController.text = _user?.displayName ?? '';
    _loadSavedCount();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCount() async {
    final books = await _firestoreService.getSavedBooks();
    setState(() {
      _savedBooksCount = books.length;
      _loadingCount = false;
    });
  }

  Future<void> _saveUsername() async {
    final newName = _usernameController.text.trim();
    if (newName.isEmpty) return;
    setState(() => _savingUsername = true);
    await _user?.updateDisplayName(newName);
    setState(() {
      _savingUsername = false;
      _editingUsername = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('USERNAME UPDATED →'),
        backgroundColor: Colors.black,
      ),
    );
  }

  Future<void> _logout() async {
    await AuthService().signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'UNKNOWN';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
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

            // Profile header block
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        top: BorderSide(color: Colors.black, width: 2),
                        bottom: BorderSide(color: Colors.black, width: 2),
                        left: BorderSide(color: Colors.black, width: 2),
                        right: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFFFF3F00),
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'READER',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _user?.displayName?.toUpperCase().isNotEmpty == true
                              ? _user!.displayName!.toUpperCase()
                              : 'SET USERNAME →',
                          style: const TextStyle(
                            fontFamily: 'JimNightshade',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section label
            _sectionLabel('ACCOUNT'),
            const SizedBox(height: 12),

            // Email
            _infoTile(
              label: 'EMAIL',
              value: _user?.email ?? 'N/A',
              icon: Icons.mail_outline,
            ),

            const SizedBox(height: 10),

            // Joined date
            _infoTile(
              label: 'JOINED',
              value: _formatDate(_user?.metadata.creationTime),
              icon: Icons.calendar_today_outlined,
            ),

            const SizedBox(height: 10),

            // Saved books count
            _infoTile(
              label: 'BOOKS SAVED',
              value: _loadingCount ? '...' : '$_savedBooksCount',
              icon: Icons.bookmark_outline,
            ),

            const SizedBox(height: 24),
            const ReadingActivityGraph(),
            const SizedBox(height: 24),

            // Username section
            _sectionLabel('USERNAME'),
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
              child: _editingUsername
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _usernameController,
                            autofocus: true,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                              letterSpacing: 1,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'ENTER USERNAME',
                              hintStyle: TextStyle(
                                color: Colors.black38,
                                fontSize: 13,
                                letterSpacing: 2,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _savingUsername ? null : _saveUsername,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            color: Colors.black,
                            child: _savingUsername
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFFF3F00),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'SAVE',
                                    style: TextStyle(
                                      fontFamily: 'JimNightshade',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF3F00),
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => setState(() => _editingUsername = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: const Text(
                              'X',
                              style: TextStyle(
                                fontFamily: 'JimNightshade',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () => setState(() => _editingUsername = true),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _user?.displayName?.isNotEmpty == true
                                  ? _user!.displayName!
                                  : 'Tap to set username',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: _user?.displayName?.isNotEmpty == true
                                    ? Colors.black
                                    : Colors.black38,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          Container(
                            color: const Color(0xFFFF3F00),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 32),

            // Logout button
            GestureDetector(
              onTap: _logout,
              child: Container(
                width: double.infinity,
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
                    Icon(Icons.logout, color: Colors.black, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'LOGOUT →',
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

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Container(
      // color: Color(0xFFFF3F00),
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

  Widget _infoTile({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      child: Row(
        children: [
          Container(
            // color: Colors.black,
            padding: const EdgeInsets.all(6),
            child: Icon(icon, color: const Color(0xFFFF3F00), size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
