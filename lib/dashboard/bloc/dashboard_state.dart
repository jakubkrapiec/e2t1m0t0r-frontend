class DashboardState {
  DashboardState()
      : duration = 0,
        processingStage = DashboardProcessingStage.idle;
  DashboardState.fromValues(this.duration, this.processingStage);
  final int duration;
  final DashboardProcessingStage processingStage;
}

enum DashboardProcessingStage {
  idle,
  loading,
  error,
}
