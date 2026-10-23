
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ONE MORE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget _buildRing(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = (_controller.value + delay) % 1.0;
        final scale = 1.0 + progress * 3.5;
        final opacity = (1.0 - progress) * 0.8;

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildPulse() {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radiating rings
          _buildRing(0.5),
          _buildRing(1),

          // Solid red center
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x55FF0000),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 48),

            const Text(
              'ONE',
              style: TextStyle(
                color: Colors.black,
                fontSize: 70,
                fontWeight: FontWeight.w800,
              ),
            ),

            const Text(
              'MORE',
              style: TextStyle(
                color: Colors.red,
                fontSize: 70,
                fontWeight: FontWeight.w800,
              ),
            ),

            const Text(
              'TAP AT THE RIGHT MOMENT',
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 80),

            // Animated heartbeat
            _buildPulse(),

            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                print('hello');
              },
              child: const Text('PLAY', style: TextStyle(color: Colors.white),),
              style: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll(Colors.black),
                shape: WidgetStatePropertyAll<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
