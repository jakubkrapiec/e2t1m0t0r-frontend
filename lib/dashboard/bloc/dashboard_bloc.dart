import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:e2t1m0t0r_frontend/dashboard/bloc/dashboard_events.dart';
import 'package:e2t1m0t0r_frontend/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState()) {
    on<ProcessSingleModelEvent>(processModel);
  }

  Future<void> processModel(ProcessSingleModelEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardState.fromValues(0, DashboardProcessingStage.loading));
    final dio = Dio();

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(event.file, filename: 'model.stl'),
    });

    final response = await dio.post<String>(_apiEndpointUrl, data: formData);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.data!) as Map;
      emit(DashboardState.fromValues(body['duration'] as int, DashboardProcessingStage.idle));
    } else {
      emit(DashboardState.fromValues(0, DashboardProcessingStage.error));
    }
  }

  static const _apiEndpointUrl =
      'https://e2t1m0t0r-backend.graystone-39bdb123.germanywestcentral.azurecontainerapps.io/estimate';
}
