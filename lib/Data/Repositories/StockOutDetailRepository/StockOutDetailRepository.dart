import 'dart:convert';

import 'package:chrome_flutter/Utils/SharedPreferences/TokenHelper.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';
import '../../Models/APIResult/APIResult.dart';
import '../../Models/PagedResponse/PagedResponse.dart';
import '../../Models/StockOutDetailDTO/StockOutDetailResponseDTO.dart';

class StockOutDetailRepository {
  Future<APIResult<PagedResponse<StockOutDetailResponseDTO>>>
  GetAllStockOutDetails(String stockOutCode, int page) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url =
          '${API_Constants.baseUrl}/StockOut/${Uri.encodeComponent(stockOutCode)}/StockOutDetail/GetAllStockOutDetails?page=$page&pageSize=10';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        return APIResult<PagedResponse<StockOutDetailResponseDTO>>.fromJson(
          jsonResponse,
          (data) => PagedResponse<StockOutDetailResponseDTO>.fromJson(
            data,
            (item) => StockOutDetailResponseDTO.fromJson(item),
          ),
        );
      } else {
        final jsonResponse = json.decode(response.body);
        return new APIResult<PagedResponse<StockOutDetailResponseDTO>>(
          Success: false,
          Message: jsonResponse['Message'],
          Data: null,
        );
      }
    } catch (e) {
      return new APIResult<PagedResponse<StockOutDetailResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }
}
