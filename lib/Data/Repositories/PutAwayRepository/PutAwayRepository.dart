import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';
import 'package:chrome_flutter/Data/Models/PutAwayDTO/PutAwayAndDetailResponseDTO.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';
import '../../../Utils/SharedPreferences/ApplicableLocationHelper.dart';
import '../../../Utils/SharedPreferences/TokenHelper.dart';
import '../../../Utils/SharedPreferences/UserNameHelper.dart';
import '../../Models/PutAwayDTO/PutAwayResponseDTO.dart';

class PutAwayRepository {
  Future<APIResult<PagedResponse<PutAwayResponseDTO>>>
  getAllPutAwaysAsyncWithResponsible(int page) async {
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
            '${API_Constants.baseUrl}/PutAway/GetAllPutAwaysAsyncWithResponsible?$warehouseCodesQuery&responsible=$responsible&page=$page&pageSize=10';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return APIResult<PagedResponse<PutAwayResponseDTO>>.fromJson(
            jsonResponse,
            (data) => PagedResponse<PutAwayResponseDTO>.fromJson(
              data,
              (item) => PutAwayResponseDTO.fromJson(item),
            ),
          );
        } else {
          final jsonResponse = json.decode(response.body);
          return new APIResult<PagedResponse<PutAwayResponseDTO>>(
            Success: false,
            Message: jsonResponse['Message'],
            Data: null,
          );
        }
      } else {
        throw Exception('Không thuộc kho nào: $applicableLocation');
      }
    } catch (e) {
      return new APIResult<PagedResponse<PutAwayResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<PagedResponse<PutAwayResponseDTO>>>
  searchPutAwaysAsyncWithResponsible(String textToSearch, int page) async {
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
            '${API_Constants.baseUrl}/PutAway/SearchPutAwaysAsyncWithResponsible?$warehouseCodesQuery&responsible=$responsible&textToSearch=$textToSearch&page=$page&pageSize=10';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return APIResult<PagedResponse<PutAwayResponseDTO>>.fromJson(
            jsonResponse,
            (data) => PagedResponse<PutAwayResponseDTO>.fromJson(
              data,
              (item) => PutAwayResponseDTO.fromJson(item),
            ),
          );
        } else {
          final jsonResponse = json.decode(response.body);
          return new APIResult<PagedResponse<PutAwayResponseDTO>>(
            Success: false,
            Message: jsonResponse['Message'],
            Data: null,
          );
        }
      } else {
        throw Exception('Không thuộc kho nào: $applicableLocation');
      }
    } catch (e) {
      return new APIResult<PagedResponse<PutAwayResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<PutAwayAndDetailResponseDTO>> GetPutAwayContainsCodeAsync(
    String orderCode,
  ) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url =
          '${API_Constants.baseUrl}/PutAway/GetPutAwayContainsCodeAsync?orderCode=$orderCode';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return APIResult<PutAwayAndDetailResponseDTO>.fromJson(
          jsonResponse,
          (data) => PutAwayAndDetailResponseDTO.fromJson(data),
        );
      } else {
        final jsonResponse = json.decode(response.body);
        return new APIResult<PutAwayAndDetailResponseDTO>(
          Success: false,
          Message: jsonResponse['Message'],
          Data: null,
        );
      }
    } catch (e) {
      return new APIResult<PutAwayAndDetailResponseDTO>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<List<PutAwayResponseDTO>>> GetListPutAwayContainCodeAsync(
    String orderCode,
  ) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url =
          '${API_Constants.baseUrl}/PutAway/GetListPutAwayContainsCodeAsync?orderCode=$orderCode';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return APIResult<List<PutAwayResponseDTO>>.fromJson(
          jsonResponse,
          (data) => List<PutAwayResponseDTO>.from(
            data.map((item) => PutAwayResponseDTO.fromJson(item)),
          ),
        );
      } else {
        final jsonResponse = json.decode(response.body);
        return new APIResult<List<PutAwayResponseDTO>>(
          Success: false,
          Message: jsonResponse['Message'],
          Data: null,
        );
      }
    } catch (e) {
      return new APIResult<List<PutAwayResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }
}
