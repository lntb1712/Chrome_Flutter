import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';
import 'package:chrome_flutter/Data/Models/TransferDetailDTO/TransferDetailResponseDTO.dart';
import 'package:chrome_flutter/Utils/SharedPreferences/TokenHelper.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';

class TransferDetailRepository {
  Future<APIResult<PagedResponse<TransferDetailResponseDTO>>>
  GetTransferDetailsByTransferCode(String transferCode) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url =
          '${API_Constants.baseUrl}/TransferDetail/GetTransferDetailsByTransferCode?transferCode=$transferCode';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return new APIResult<PagedResponse<TransferDetailResponseDTO>>.fromJson(
          jsonResponse,
          (data) => PagedResponse<TransferDetailResponseDTO>.fromJson(
            data,
            (item) => TransferDetailResponseDTO.fromJson(item),
          ),
        );
      } else {
        final jsonResponse = json.decode(response.body);
        return new APIResult<PagedResponse<TransferDetailResponseDTO>>(
          Success: false,
          Message: jsonResponse['Message'],
          Data: null,
        );
      }
    } catch (e) {
      return new APIResult<PagedResponse<TransferDetailResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }
}
