import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/StockInDetailDTO/StockInDetailRequestDTO.dart';
import 'package:chrome_flutter/Utils/Constants/API_Constants.dart';
import 'package:chrome_flutter/Utils/SharedPreferences/TokenHelper.dart';
import 'package:http/http.dart' as http;

import '../../Models/PagedResponse/PagedResponse.dart';
import '../../Models/StockInDetailDTO/StockInDetailResponseDTO.dart';

class StockInDetailRepository {
  Future<APIResult<PagedResponse<StockInDetailResponseDTO>>>
  getAllStockInDetails(String stockInCode, int page) async {
    final token = await TokenHelper.getAccessToken();
    final url = Uri.parse(
      '${API_Constants.baseUrl}/StockIn/${stockInCode}/StockInDetail/GetAllStockInDetails?page=$page&pageSize=10',
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
      return APIResult<PagedResponse<StockInDetailResponseDTO>>.fromJson(
        jsonResponse,
        (data) => PagedResponse<StockInDetailResponseDTO>.fromJson(
          data,
          (item) => StockInDetailResponseDTO.fromJson(item),
        ),
      );
    } else {
      final jsonResponse = json.decode(response.body);
      return new APIResult<PagedResponse<StockInDetailResponseDTO>>(
        Success: false,
        Message: jsonResponse['Message'],
        Data: null,
      );
    }
  }

  Future<APIResult<bool>> UpdateStockInDetail(
    StockInDetailRequestDTO stockInDetail,
  ) async {
    final token = await TokenHelper.getAccessToken();
    final url = Uri.parse(
      '${API_Constants.baseUrl}/StockIn/${stockInDetail.StockInCode}/StockInDetail/UpdateStockInDetail',
    );
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(stockInDetail.toJson()),
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
  }
}
