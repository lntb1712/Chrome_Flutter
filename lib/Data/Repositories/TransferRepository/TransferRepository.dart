import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';
import 'package:chrome_flutter/Data/Models/TransferDTO/TransferResponseDTO.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';
import '../../../Utils/SharedPreferences/ApplicableLocationHelper.dart';
import '../../../Utils/SharedPreferences/TokenHelper.dart';
import '../../../Utils/SharedPreferences/UserNameHelper.dart';

class TransferRepository {
  Future<APIResult<PagedResponse<TransferResponseDTO>>>
  GetAllTransfersWithResponsible(int page) async {
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
            '${API_Constants.baseUrl}/Transfer/GetAllTransfersWithResponsible?$warehouseCodesQuery&responsible=$responsible&page=$page&pageSize=10';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return APIResult<PagedResponse<TransferResponseDTO>>.fromJson(
            jsonResponse,
            (data) => PagedResponse<TransferResponseDTO>.fromJson(
              data,
              (item) => TransferResponseDTO.fromJson(item),
            ),
          );
        } else {
          final jsonResponse = json.decode(response.body);
          return new APIResult<PagedResponse<TransferResponseDTO>>(
            Success: false,
            Message: jsonResponse['Message'],
            Data: null,
          );
        }
      } else {
        throw new Exception('Không thuộc kho nào: $applicableLocation');
      }
    } catch (e) {
      return new APIResult<PagedResponse<TransferResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<PagedResponse<TransferResponseDTO>>>
  SearchTransfersAsyncWithResponsible(String textToSearch, int page) async {
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
            '${API_Constants.baseUrl}/Transfer/SearchTransfersAsyncWithResponsible?$warehouseCodesQuery&responsible=$responsible&textToSearch=$textToSearch&page=$page&pageSize=10';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return APIResult<PagedResponse<TransferResponseDTO>>.fromJson(
            jsonResponse,
            (data) => PagedResponse<TransferResponseDTO>.fromJson(
              data,
              (item) => TransferResponseDTO.fromJson(item),
            ),
          );
        } else {
          final jsonResponse = json.decode(response.body);
          return new APIResult<PagedResponse<TransferResponseDTO>>(
            Success: false,
            Message: jsonResponse['Message'],
            Data: null,
          );
        }
      } else {
        throw new Exception('Không thuộc kho nào: $applicableLocation');
      }
    } catch (e) {
      return new APIResult<PagedResponse<TransferResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }
}
