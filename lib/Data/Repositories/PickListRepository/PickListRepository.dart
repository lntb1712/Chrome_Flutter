import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';
import '../../../Utils/SharedPreferences/ApplicableLocationHelper.dart';
import '../../../Utils/SharedPreferences/TokenHelper.dart';
import '../../../Utils/SharedPreferences/UserNameHelper.dart';
import '../../Models/APIResult/APIResult.dart';
import '../../Models/PagedResponse/PagedResponse.dart';
import '../../Models/PickListDTO/PickAndDetailResponseDTO.dart';
import '../../Models/PickListDTO/PickListResponseDTO.dart';

class PickListRepository {
  Future<APIResult<PagedResponse<PickListResponseDTO>>>
  GetAllPickListsAsyncWithResponsible() async {
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
            '${API_Constants.baseUrl}/PickList/GetAllPickListsAsyncWithResponsible?$warehouseCodesQuery&responsible=$responsible&page=1&pageSize=10';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return APIResult<PagedResponse<PickListResponseDTO>>.fromJson(
            jsonResponse,
            (data) => PagedResponse<PickListResponseDTO>.fromJson(
              data,
              (item) => PickListResponseDTO.fromJson(item),
            ),
          );
        } else {
          final jsonResponse = json.decode(response.body);
          return new APIResult<PagedResponse<PickListResponseDTO>>(
            Success: false,
            Message: jsonResponse['Message'],
            Data: null,
          );
        }
      } else {
        throw Exception('Không thuộc kho nào: $applicableLocation');
      }
    } catch (e) {
      return new APIResult<PagedResponse<PickListResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<PagedResponse<PickListResponseDTO>>>
  SearchPickListsAsyncWithResponsible(String textToSearch) async {
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
            '${API_Constants.baseUrl}/PickList/SearchPickListsAsyncWithResponsible?$warehouseCodesQuery&responsible=$responsible&textToSearch=$textToSearch&page=1&pageSize=10';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return APIResult<PagedResponse<PickListResponseDTO>>.fromJson(
            jsonResponse,
            (data) => PagedResponse<PickListResponseDTO>.fromJson(
              data,
              (item) => PickListResponseDTO.fromJson(item),
            ),
          );
        } else {
          final jsonResponse = json.decode(response.body);
          return new APIResult<PagedResponse<PickListResponseDTO>>(
            Success: false,
            Message: jsonResponse['Message'],
            Data: null,
          );
        }
      } else {
        throw Exception('Không thuộc kho nào: $applicableLocation');
      }
    } catch (e) {
      return new APIResult<PagedResponse<PickListResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<PickAndDetailResponseDTO>> GetPickListContainCodeAsync(
    String orderCode,
  ) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url =
          '${API_Constants.baseUrl}/PickList/GetPickListContainCodeAsync?orderCode=$orderCode';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return APIResult<PickAndDetailResponseDTO>.fromJson(
          jsonResponse,
          (data) => PickAndDetailResponseDTO.fromJson(data),
        );
      } else {
        final jsonResponse = json.decode(response.body);
        return new APIResult<PickAndDetailResponseDTO>(
          Success: false,
          Message: jsonResponse['Message'],
          Data: null,
        );
      }
    } catch (e) {
      return new APIResult<PickAndDetailResponseDTO>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }
}
