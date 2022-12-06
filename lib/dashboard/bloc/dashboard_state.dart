class DashboardState {
  DashboardState()
      : fileDurations = {},
        processingStage = DashboardProcessingStage.idle;
  DashboardState.fromValues(this.fileDurations, this.processingStage);
  final Map<String, int> fileDurations;
  final DashboardProcessingStage processingStage;
}

enum DashboardProcessingStage {
  idle,
  loading,
  error,
}
