class Obstacle {
  Obstacle({
    required this.x,
    required this.y,
    this.width = 24,
    this.height = 80,
  });

  double x;
  final double y;
  final double width;
  final double height;
}