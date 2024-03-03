class PositionData {
  PositionData(
      {required this.position,
      required this.bufferedPosition,
      required this.durations});
  final Duration position;
  final Duration bufferedPosition;
  final Duration durations;
}