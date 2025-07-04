import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/ManufacturingOrderDTO/ManufacturingOrderRequestDTO.dart';
import 'package:chrome_flutter/Utils/SharedPreferences/UserNameHelper.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';
import '../../../Utils/SharedPreferences/ApplicableLocationHelper.dart';
import '../../../Utils/SharedPreferences/TokenHelper.dart';
import '../../Models/ManufacturingOrderDTO/ManufacturingOrderResponseDTO.dart';
import '../../Models/PagedResponse/PagedResponse.dart';

class ManufacturingOrderRepository {
  Future<APIResult<PagedResponse<ManufacturingOrderResponseDTO>>>
  GetAllManufacturingOrdersAsyncWithResponsible(int page) async {
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
            '${API_Constants.baseUrl}/ManufacturingOrder/GetAllManufacturingOrdersAsyncWithResponsible?$warehouseCodesQuery&responsible=$responsible&page=$page&pageSize=10';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return APIResult<
            PagedResponse<ManufacturingOrderResponseDTO>
          >.fromJson(
            jsonResponse,
            (data) => PagedResponse<ManufacturingOrderResponseDTO>.fromJson(
              data,
              (item) => ManufacturingOrderResponseDTO.fromJson(item),
            ),
          );
        } else {
          final jsonResponse = json.decode(response.body);
          return new APIResult<PagedResponse<ManufacturingOrderResponseDTO>>(
            Success: false,
            Message: jsonResponse['Message'],
            Data: null,
          );
        }
      } else {
        throw new Exception('Không thuộc kho nào: $applicableLocation');
      }
    } catch (e) {
      return new APIResult<PagedResponse<ManufacturingOrderResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<PagedResponse<ManufacturingOrderResponseDTO>>>
  SearchManufacturingOrdersAsyncWithResponsible(
    String textToSearch,
    int page,
  ) async {
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
            '${API_Constants.baseUrl}/ManufacturingOrder/SearchManufacturingOrdersAsyncWithResponsible?$warehouseCodesQuery&responsible=$responsible&textToSearch=$textToSearch&page=$page&pageSize=10';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return APIResult<
            PagedResponse<ManufacturingOrderResponseDTO>
          >.fromJson(
            jsonResponse,
            (data) => PagedResponse<ManufacturingOrderResponseDTO>.fromJson(
              data,
              (item) => ManufacturingOrderResponseDTO.fromJson(item),
            ),
          );
        } else {
          final jsonResponse = json.decode(response.body);
          return new APIResult<PagedResponse<ManufacturingOrderResponseDTO>>(
            Success: false,
            Message: jsonResponse['Message'],
            Data: null,
          );
        }
      } else {
        throw new Exception('Không thuộc kho nào: $applicableLocation');
      }
    } catch (e) {
      return new APIResult<PagedResponse<ManufacturingOrderResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }

  Future<APIResult<bool>> UpdateManufacturingOrder(
    ManufacturingOrderRequestDTO ManufacturingOrderRequestDTO,
  ) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url =
          '${API_Constants.baseUrl}/ManufacturingOrder/UpdateManufacturingOrder';
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(ManufacturingOrderRequestDTO.toJson()),
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
