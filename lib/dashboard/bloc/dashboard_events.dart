import 'dart:typed_data';

abstract class DashboardEvent {}

class ProcessSingleModelEvent extends DashboardEvent {
  ProcessSingleModelEvent(this.file);
  final Uint8List file;
}
