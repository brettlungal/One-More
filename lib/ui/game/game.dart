
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'models/obstacle.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  final List<Obstacle> _obstacles = [];
  final Random _random = Random();
  

  Duration _lastElapsed = Duration.zero;

  double _gameTime = 0;
  double _spawnAccumulator = 0;
  double _screenWidth = 0;
  double _screenHeight = 0;
  int _score = 0;

  int _level = 1;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final dt =
        (elapsed - _lastElapsed).inMicroseconds / 1000000.0;

    _lastElapsed = elapsed;

    // Avoid a huge movement after a pause or lag spike.
    final delta = min(dt, 0.05);

    setState(() {
      _gameTime += delta;

      // Increase the level every 15 seconds.
      _level = 1 + (_gameTime ~/ 15);

      // Obstacles move faster at higher levels.
      final speed = 240.0 + (_level - 1) * 25.0;

      // Obstacles spawn more frequently at higher levels.
      final spawnInterval =
          max(0.45, 1.5 - (_level - 1) * 0.1);

      _spawnAccumulator += delta;

      while (_spawnAccumulator >= spawnInterval) {
        _spawnAccumulator -= spawnInterval;
        _spawnObstacle();
      }

      // Move obstacles from right to left.
      for (final obstacle in _obstacles) {
        obstacle.x -= speed * delta;
      }

      final double scoringLine =
          (_screenWidth / 2) + (50 / 2);

      // Increment score when obstacles pass the player.
      for (final obstacle in _obstacles) {
        if (!obstacle.scored &&
            obstacle.x + obstacle.width < scoringLine) {
          obstacle.scored = true;
          _score++;
        }
      }

      // Remove obstacles that have completely left the screen.
      _obstacles.removeWhere(
        (obstacle) => obstacle.x + obstacle.width < 0,
      );
    });
  }

  void _spawnObstacle() {
    if (_screenHeight <= 100) return;

    const obstacleHeight = 80.0;

    final y = _random.nextDouble() *
        (_screenHeight - obstacleHeight);

    _obstacles.add(
      Obstacle(
        x: _screenWidth + 24,
        y: y,
        height: obstacleHeight,
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),
      body: LayoutBuilder(
        builder: (context, constraints) {
          _screenWidth = constraints.maxWidth;
          _screenHeight = constraints.maxHeight;

          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Level indicator.
              Positioned(
                top: 24,
                left: 0,
                right: 0,
                child: Text(
                  'LEVEL $_level',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                top: 48,
                left: 0,
                right: 0,
                child: Text(
                  'SCORE: $_score',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),

              // Moving obstacles.
              for (final obstacle in _obstacles)
                Positioned(
                  left: obstacle.x,
                  top: obstacle.y,
                  child: Container(
                    width: obstacle.width,
                    height: obstacle.height,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

              // Stationary player.
              Center(
                child: Hero(
                  tag: 'game-pulse',
                  child: Container(
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
                ),
              ),

              // Reset button.
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('RESET'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
