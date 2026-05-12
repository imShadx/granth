import 'package:flutter/material.dart';
import 'package:granth/pages/mainpage.dart';
import 'package:granth/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _offsetAnimation = Tween<double>(
      begin: 0,
      end: -18,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF3F00),
      body: Stack(
        children: [
          // Background accent block
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Container(
              color: const Color(0xFFFF3F00), // brutalist orange-red
            ),
          ),

          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),

                // Floating book icon
                AnimatedBuilder(
                  animation: _offsetAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _offsetAnimation.value),
                      child: child,
                    );
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F0E8),
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(6, 6),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_stories,
                      size: 80,
                      color: Color(0xFFFF3F00),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // App name
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  // decoration: BoxDecoration(
                  //   // color: Colors.black,
                  //   border: Border.all(color: Colors.black, width: 3),
                  // ),
                  child: const Text(
                    'GRANTH',
                    style: TextStyle(
                      fontFamily: 'Comforter',
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      color: Colors.black,
                      letterSpacing: 4,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'read yourself to sleep.',
                  style: TextStyle(
                    fontFamily: 'JimNightshade',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),

                const Spacer(),

                const Text(
                  'SWIPE UP',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 3,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(
                  Icons.keyboard_arrow_up,
                  size: 24,
                  color: Colors.black,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Draggable login sheet
          DraggableScrollableSheet(
            initialChildSize: 0.07,
            minChildSize: 0.07,
            maxChildSize: 0.62,
            snap: true,
            snapSizes: const [0.07, 0.62],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F0E8).withOpacity(0.95),
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 3),
                    left: BorderSide(color: Colors.black, width: 3),
                    right: BorderSide(color: Colors.black, width: 3),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 6),
                          child: Container(
                            width: 44,
                            height: 5,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Label
                            Container(
                              // color: const Color(0xFFFF3F00),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              child: const Text(
                                'WELCOME BACK',
                                style: TextStyle(
                                  fontFamily: 'Comforter',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Email field
                            _brutalField(
                              hint: 'EMAIL',
                              controller: _emailController,
                            ),

                            const SizedBox(height: 16),

                            // Password field
                            _brutalField(
                              hint: 'PASSWORD',
                              obscure: true,
                              controller: _passwordController,
                            ),

                            const SizedBox(height: 28),

                            // Login button
                            GestureDetector(
                              onTap: () async {
                                if (_emailController.text.trim().isEmpty ||
                                    _passwordController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('FILL IN ALL FIELDS →'),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                  return;
                                }
                                final error = await AuthService().signIn(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                                if (error == null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainPage(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(error),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xFFFF3F00),
                                      offset: Offset(5, 5),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'LOGIN →',
                                    style: TextStyle(
                                      fontFamily: 'JimNightshade',
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF5F0E8),
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () async {
                                if (_emailController.text.trim().isEmpty ||
                                    _passwordController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('FILL IN ALL FIELDS →'),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                  return;
                                }
                                final error = await AuthService().signUp(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                                if (error == null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainPage(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(error),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                }
                              },
                              child: const Center(
                                child: Text(
                                  'No account? SIGN UP →',
                                  style: TextStyle(
                                    fontFamily: 'JimNightshade',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _brutalField({
    required String hint,
    bool obscure = false,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F0E8),
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 3),
          top: BorderSide(color: Colors.black, width: 3),
          left: BorderSide(color: Colors.black, width: 3),
          right: BorderSide(color: Colors.black, width: 3),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.black,
          letterSpacing: 1,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.black38,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 13,
          ),
          filled: true,
          fillColor: const Color(0xFFF5F0E8),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
