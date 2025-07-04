import 'dart:convert';

import 'package:chrome_flutter/Data/Models/StockTakeDetailDTO/StockTakeDetailRequestDTO.dart';
import 'package:chrome_flutter/Data/Models/StockTakeDetailDTO/StockTakeDetailResponseDTO.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';
import '../../../Utils/SharedPreferences/TokenHelper.dart';
import '../../Models/APIResult/APIResult.dart';
import '../../Models/PagedResponse/PagedResponse.dart';

class StockTakeDetailRepository {
  Future<APIResult<PagedResponse<StockTakeDetailResponseDTO>>>
  GetStockTakeDetailsByStockTakeCode(String stockTakeCode, int page) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url =
          '${API_Constants.baseUrl}/StockTake/$stockTakeCode/StockTakeDetail/GetStockTakeDetailsByStockTakeCode?stockTakeCode=$stockTakeCode&page=$page&pageSize=10';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return new APIResult<
          PagedResponse<StockTakeDetailResponseDTO>
        >.fromJson(
          jsonResponse,
          (data) => PagedResponse<StockTakeDetailResponseDTO>.fromJson(
            data,
            (item) => StockTakeDetailResponseDTO.fromJson(item),
          ),
        );
      } else {
        final jsonResponse = json.decode(response.body);
        return new APIResult<PagedResponse<StockTakeDetailResponseDTO>>(
          Success: false,
          Message: jsonResponse['Message'],
          Data: null,
        );
      }
    } catch (e) {
      return new APIResult<PagedResponse<StockTakeDetailResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<bool>> UpdateStockTakeDetail(
    StockTakeDetailRequestDTO stockTakeDetail,
  ) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url =
          '${API_Constants.baseUrl}/StockTake/${stockTakeDetail.StocktakeCode}/StockTakeDetail/UpdateStockTakeDetail';

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return new APIResult<bool>.fromJson(jsonResponse, (data) => data);
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
