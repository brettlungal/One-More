import 'package:flutter/material.dart';
import 'package:one_more/ui/core/ui/common_button.dart';
import 'package:one_more/ui/home/widgets/pulse.dart';
import 'package:one_more/ui/game/game.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  bool _isPulseAnimating = true;

  @override
  void initState(){
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.2, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  const SizedBox(height: 108),
                  const Text(
                    'ONE',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 70,
                      fontWeight: FontWeight.w800,
                      height: 0.85,
                    ),
                  ),
                  const Text(
                    'MORE',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 70,
                      fontWeight: FontWeight.w800,
                      height: 0.85,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'HOW FAR CAN YOU MAKE IT?',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            Pulse(isAnimating: _isPulseAnimating,),
            SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: CommonButton(
                        onPressed: () async {
                          setState(() {
                            _isPulseAnimating = false;
                          });

                          await _controller.forward();

                          if (!mounted) return;

                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 700),
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return const Game();
                              },
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}