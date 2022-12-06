import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:e2t1m0t0r_frontend/dashboard/bloc/dashboard_events.dart';
import 'package:e2t1m0t0r_frontend/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState()) {
    on<ProcessModelsEvent>(_processModels);
  }

  Future<void> _processModels(ProcessModelsEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardState.fromValues({}, DashboardProcessingStage.loading));
    final dio = Dio();

    if (event.models.length == 1) {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(event.models.values.single, filename: event.models.keys.single),
      });

      final response = await dio.post<String>('$_apiUrl/estimate', data: formData);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.data!) as Map;
        emit(
          DashboardState.fromValues(
            {event.models.keys.single: body['duration'] as int},
            DashboardProcessingStage.idle,
          ),
        );
      } else {
        emit(DashboardState.fromValues({'error': 0}, DashboardProcessingStage.error));
      }
    } else {
      final formDataMap = <String, dynamic>{'files_number': event.models.length};
      for (var i = 0; i < event.models.length; i++) {
        formDataMap.putIfAbsent(
          'file_$i',
          () => MultipartFile.fromBytes(event.models.values.toList()[i], filename: event.models.keys.toList()[i]),
        );
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await dio.post<String>('$_apiUrl/estimate_multiple', data: formData);
      if (response.statusCode == 200) {
        final body = (jsonDecode(response.data!) as Map).cast<String, int>();
        emit(DashboardState.fromValues(body, DashboardProcessingStage.idle));
      } else {
        emit(DashboardState.fromValues({'error': 0}, DashboardProcessingStage.error));
      }
    }
  }

  static const _apiUrl = 'https://e2t1m0t0r-backend.graystone-39bdb123.germanywestcentral.azurecontainerapps.io';
}
