import 'dart:typed_data';

abstract class DashboardEvent {}

class ProcessModelsEvent extends DashboardEvent {
  ProcessModelsEvent(this.models);
  final Map<String, Uint8List> models;
}
