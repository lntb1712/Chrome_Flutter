import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';
import 'package:chrome_flutter/Utils/SharedPreferences/TokenHelper.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';
import '../../../Utils/SharedPreferences/ApplicableLocationHelper.dart';
import '../../../Utils/SharedPreferences/UserNameHelper.dart';
import '../../Models/StockTakeDTO/StockTakeResponseDTO.dart';

class StockTakeRepository {
  Future<APIResult<PagedResponse<StockTakeResponseDTO>>>
  GetAllStockTakesAsyncWithResponsible(int page) async {
    try {
      final applicableLocation =
          await ApplicableLocationHelper.getApplicableLocation();
      final responsible = await UserNameHelper.getUserName();
      final token = await TokenHelper.getAccessToken();

      if (applicableLocation != null && applicableLocation.isNotEmpty) {
        final code = applicableLocation.split(',');
        final warehouseCodesQuery = code
            .map((code) => 'warehouseCodes=$code')
            .join('&');
        final url =
            '${API_Constants.baseUrl}/StockTake/GetAllStockTakesAsyncWithResponsible?$warehouseCodesQuery&responsible=$responsible&page=$page&pageSize=10';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return APIResult<PagedResponse<StockTakeResponseDTO>>.fromJson(
            jsonResponse,
            (data) => PagedResponse<StockTakeResponseDTO>.fromJson(
              data,
              (item) => StockTakeResponseDTO.fromJson(item),
            ),
          );
        } else {
          final jsonResponse = json.decode(response.body);
          return new APIResult<PagedResponse<StockTakeResponseDTO>>(
            Success: false,
            Message: jsonResponse['Message'],
            Data: null,
          );
        }
      } else {
        throw new Exception('Không thuộc kho nào: $applicableLocation');
      }
    } catch (e) {
      return new APIResult<PagedResponse<StockTakeResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<PagedResponse<StockTakeResponseDTO>>>
  SearchStockTakesAsyncWithResponsible(String textToSearch, int page) async {
    try {
      final applicableLocation =
          await ApplicableLocationHelper.getApplicableLocation();
      final responsible = await UserNameHelper.getUserName();
      final token = await TokenHelper.getAccessToken();

      if (applicableLocation != null && applicableLocation.isNotEmpty) {
        final code = applicableLocation.split(',');
        final warehouseCodesQuery = code
            .map((code) => 'warehouseCodes=$code')
            .join('&');
        final url =
            '${API_Constants.baseUrl}/StockTake/SearchStockTakesAsyncWithResponsible?$warehouseCodesQuery&responsible=$responsible&textToSearch=$textToSearch&page=$page&pageSize=10';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return APIResult<PagedResponse<StockTakeResponseDTO>>.fromJson(
            jsonResponse,
            (data) => PagedResponse<StockTakeResponseDTO>.fromJson(
              data,
              (item) => StockTakeResponseDTO.fromJson(item),
            ),
          );
        } else {
          final jsonResponse = json.decode(response.body);
          return new APIResult<PagedResponse<StockTakeResponseDTO>>(
            Success: false,
            Message: jsonResponse['Message'],
            Data: null,
          );
        }
      } else {
        throw new Exception('Không thuộc kho nào: $applicableLocation');
      }
    } catch (e) {
      return new APIResult<PagedResponse<StockTakeResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }
}
