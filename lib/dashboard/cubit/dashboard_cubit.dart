import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DashboardCubit extends Cubit<int> {
  DashboardCubit() : super(0);

  Future<void> processModel(Uint8List modelFile) async {
    final dio = Dio();

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(modelFile, filename: 'model.stl'),
    });

    final response = await dio.post<String>(_apiEndpointUrl, data: formData);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.data!) as Map;
      emit(body['duration'] as int);
    } else {
      emit(-1);
    }
  }

  static const _apiEndpointUrl =
      'https://e2t1m0t0r-backend.graystone-39bdb123.germanywestcentral.azurecontainerapps.io/estimate';
}
