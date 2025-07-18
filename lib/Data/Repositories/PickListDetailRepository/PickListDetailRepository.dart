import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/PickListDetailDTO/PickListDetailRequestDTO.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';
import '../../../Utils/SharedPreferences/TokenHelper.dart';
import '../../Models/PagedResponse/PagedResponse.dart';
import '../../Models/PickListDetailDTO/PickListDetailResponseDTO.dart';

class PickListDetailRepository {
  Future<APIResult<PagedResponse<PickListDetailResponseDTO>>>
  GetPickListDetailsByPickNo(String pickNo) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url =
          '${API_Constants.baseUrl}/PickList/${Uri.encodeComponent(pickNo)}/PickListDetail/GetPickListDetailsByPickNo?pickNo=$pickNo';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return APIResult<PagedResponse<PickListDetailResponseDTO>>.fromJson(
          jsonResponse,
          (data) => PagedResponse<PickListDetailResponseDTO>.fromJson(
            data,
            (item) => PickListDetailResponseDTO.fromJson(item),
          ),
        );
      } else {
        final jsonResponse = json.decode(response.body);
        return new APIResult<PagedResponse<PickListDetailResponseDTO>>(
          Success: false,
          Message: jsonResponse['Message'],
          Data: null,
        );
      }
    } catch (e) {
      return new APIResult<PagedResponse<PickListDetailResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<bool>> UpdatePickListDetail(
    PickListDetailRequestDTO pickListDetailRequestDTO,
  ) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url =
          '${API_Constants.baseUrl}/PickList/${Uri.encodeComponent(pickListDetailRequestDTO.PickNo)}/PickListDetail/UpdatePickListDetail';
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(pickListDetailRequestDTO.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return APIResult<bool>.fromJson(jsonResponse, (data) => data);
      } else {
        final jsonResponse = json.decode(response.body);
        return new APIResult<bool>(
          Success: false,
          Message: jsonResponse['Message'],
          Data: null,
        );
      }
    } catch (e) {
      return new APIResult<bool>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }
}
