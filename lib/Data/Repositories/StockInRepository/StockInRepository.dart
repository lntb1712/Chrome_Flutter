import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';
import 'package:chrome_flutter/Data/Models/StockInDTO/StockInResponseDTO.dart';
import 'package:chrome_flutter/Utils/Constants/API_Constants.dart';
import 'package:chrome_flutter/Utils/SharedPreferences/ApplicableLocationHelper.dart';
import 'package:chrome_flutter/Utils/SharedPreferences/UserNameHelper.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/SharedPreferences/TokenHelper.dart';

class StockInRepository {
  Future<APIResult<PagedResponse<StockInResponseDTO>>>
  getAllStockInWithResponsible() async {
    try {
      final applicableLocation =
          await ApplicableLocationHelper.getApplicableLocation();
      final responsible = await UserNameHelper.getUserName();
      final token = await TokenHelper.getAccessToken();
      if (applicableLocation != null && applicableLocation.isNotEmpty) {
        final code = applicableLocation.split(',');

        // Build query string cho warehouseCodes
        final warehouseCodesQuery = code
            .map((code) => 'warehouseCodes=$code')
            .join('&');

        // Build full URL
        final url =
            '${API_Constants.baseUrl}/StockIn/GetAllStockInWithResponsible?$warehouseCodesQuery'
            '&responsible=$responsible&page=1&pageSize=10';

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return APIResult<PagedResponse<StockInResponseDTO>>.fromJson(
            jsonResponse,
            (data) => PagedResponse<StockInResponseDTO>.fromJson(
              data,
              (item) => StockInResponseDTO.fromJson(item),
            ),
          );
        } else {
          final jsonResponse = json.decode(response.body);
          return new APIResult<PagedResponse<StockInResponseDTO>>(
            Success: false,
            Message: jsonResponse['Message'],
            Data: null,
          );
        }
      } else {
        throw Exception('Không thuộc kho nào: $applicableLocation');
      }
    } catch (e) {
      return new APIResult<PagedResponse<StockInResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<PagedResponse<StockInResponseDTO>>>
  searchStockInWithResponsible(String textToSearch) async {
    try {
      final applicableLocation =
          await ApplicableLocationHelper.getApplicableLocation();
      final responsible = await UserNameHelper.getUserName();
      final token = await TokenHelper.getAccessToken();
      if (applicableLocation != null && applicableLocation.isNotEmpty) {
        final code = applicableLocation.split(',');

        // Build query string cho warehouseCodes
        final warehouseCodesQuery = code
            .map((code) => 'warehouseCodes=$code')
            .join('&');

        // Build full URL
        final url =
            '${API_Constants.baseUrl}/StockIn/SearchStockInWithResponsible?$warehouseCodesQuery'
            '&responsible=$responsible&textToSearch=$textToSearch&page=1&pageSize=10';

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return APIResult<PagedResponse<StockInResponseDTO>>.fromJson(
            jsonResponse,
            (data) => PagedResponse<StockInResponseDTO>.fromJson(
              data,
              (item) => StockInResponseDTO.fromJson(item),
            ),
          );
        } else {
          final jsonResponse = json.decode(response.body);
          return new APIResult<PagedResponse<StockInResponseDTO>>(
            Success: false,
            Message: jsonResponse['Message'],
            Data: null,
          );
        }
      } else {
        throw Exception('Không thuộc kho nào: $applicableLocation');
      }
    } catch (e) {
      return new APIResult<PagedResponse<StockInResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }
}
