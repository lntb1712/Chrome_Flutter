import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';
import '../../../Utils/SharedPreferences/TokenHelper.dart';
import '../../Models/MovementDetailDTO/MovementDetailResponseDTO.dart';
import '../../Models/PagedResponse/PagedResponse.dart';

class MovementDetailRepository {
  Future<APIResult<PagedResponse<MovementDetailResponseDTO>>>
  GetMovementDetailsByMovementCode(String movementCode) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url =
          '${API_Constants.baseUrl}/MovementDetail/GetMovementDetailsByMovementCode?movementCode=${Uri.encodeComponent(movementCode)}';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return APIResult<PagedResponse<MovementDetailResponseDTO>>.fromJson(
          jsonResponse,
          (data) => PagedResponse<MovementDetailResponseDTO>.fromJson(
            data,
            (item) => MovementDetailResponseDTO.fromJson(item),
          ),
        );
      } else {
        final jsonResponse = json.decode(response.body);
        return new APIResult<PagedResponse<MovementDetailResponseDTO>>(
          Success: false,
          Message: jsonResponse['Message'],
          Data: null,
        );
      }
    } catch (e) {
      return new APIResult<PagedResponse<MovementDetailResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }
}
