import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';
import 'package:chrome_flutter/Data/Models/PutAwayDetailDTO/PutAwayDetailRequestDTO.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';
import '../../../Utils/SharedPreferences/TokenHelper.dart';
import '../../Models/PutAwayDetailDTO/PutAwayDetailResponseDTO.dart';

class PutAwayDetailRepository {
  Future<APIResult<PagedResponse<PutAwayDetailResponseDTO>>>
  getPutAwayDetailsByPutawayCode(String putAwayCode) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url = Uri.parse(
        '${API_Constants.baseUrl}/PutAway/${Uri.encodeComponent(putAwayCode)}/PutAwayDetail/GetPutAwayDetailsByPutawayCode?page=1&pageSize=10',
      );
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return APIResult<PagedResponse<PutAwayDetailResponseDTO>>.fromJson(
          jsonResponse,
          (data) => PagedResponse<PutAwayDetailResponseDTO>.fromJson(
            data,
            (item) => PutAwayDetailResponseDTO.fromJson(item),
          ),
        );
      } else {
        final jsonResponse = json.decode(response.body);
        return new APIResult<PagedResponse<PutAwayDetailResponseDTO>>(
          Success: false,
          Message: jsonResponse['Message'],
          Data: null,
        );
      }
    } catch (e) {
      return new APIResult<PagedResponse<PutAwayDetailResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<bool>> updatePutAwayDetail(
    PutAwayDetailRequestDTO putAwayDetailRequestDTO,
  ) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url = Uri.parse(
        '${API_Constants.baseUrl}/PutAway/${Uri.encodeComponent(putAwayDetailRequestDTO.PutAwayCode)}/PutAwayDetail/UpdatePutAwayDetail',
      );
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(putAwayDetailRequestDTO.toJson()),
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
