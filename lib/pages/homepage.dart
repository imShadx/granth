import 'package:flutter/material.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _offsetAnimation = Tween<double>(
      begin: 0,
      end: -20,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose(); // always clean up
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFaa6469),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Container(),
                AnimatedBuilder(
                  animation: _offsetAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _offsetAnimation.value),
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: const Icon(
                          Icons.auto_stories,
                          size: 130,
                          color: Color(0xB3c6b498),
                        ),
                      ),
                      const Icon(
                        Icons.auto_stories,
                        size: 130,
                        color: Color(0xB3c6b498),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Granth',
                  style: TextStyle(
                    fontFamily: 'Comforter',
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'read yourself to sleep',
                  style: TextStyle(
                    fontFamily: 'JimNightshade',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Spacer(), 
                Text(
                  'swipe up',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Icon(Icons.arrow_upward, size: 20, color: Colors.black),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // ---- login sheet on top ----
          DraggableScrollableSheet(
            initialChildSize: 0.05,
            minChildSize: 0.05,
            maxChildSize: 0.6,
            snap: true,
            snapSizes: const [0.05, 0.6],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Color(0xFF8B4F54).withOpacity(0.9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          fontFamily: 'Comforter',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFc6b498),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),  
                        ),
                        child: const Text('Login', 
                        style: TextStyle(color: Colors.black,
                        fontFamily: 'JimNightshade', 
                        fontSize: 25),
                        ),
                      ),
                      const SizedBox(height: 40)
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
}
