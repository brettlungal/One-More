class Obstacle {
  Obstacle({
    required this.x,
    required this.y,
    this.width = 24,
    this.height = 80,
    this.scored = false,
  });

  double x;
  final double y;
  final double width;
  final double height;
  bool scored;
}