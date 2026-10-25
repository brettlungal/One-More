import 'package:flutter/material.dart';

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // The destination for the shared Hero.
          Hero(
            tag: 'game-pulse',
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Game UI goes here.
          const Positioned(
            top: 80,
            child: Text(
              'GET READY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}