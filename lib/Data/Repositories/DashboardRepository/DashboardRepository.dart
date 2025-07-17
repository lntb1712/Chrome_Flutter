import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/DashboardDTO/HandyDashboardRequestDTO.dart';
import 'package:chrome_flutter/Data/Models/DashboardDTO/HandyDashboardResponseDTO.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';

class DashboardRepository {
  Future<APIResult<HandyDashboardResponseDTO>> GetDashboardHandyAsync(
    HandyDashboardRequestDTO handyDashboardRequestDTO,
  ) async {
    try {
      final url = Uri.parse(
        '${API_Constants.baseUrl}/Dashboard/GetHandyDashboardAsync',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(handyDashboardRequestDTO.toJson()),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return APIResult<HandyDashboardResponseDTO>.fromJson(
          jsonResponse,
          (data) => HandyDashboardResponseDTO.fromJson(data),
        );
      } else {
        final jsonResponse = json.decode(response.body);
        return new APIResult<HandyDashboardResponseDTO>(
          Success: false,
          Message: jsonResponse['Message'],
          Data: null,
        );
      }
    } catch (e) {
      return new APIResult<HandyDashboardResponseDTO>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }
}
