import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/LoginDTO/LoginResponseDTO.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';
import '../../Models/AccountDTO/AccountResponseDTO.dart';
import '../../Models/LoginDTO/LoginRequestDTO.dart';

class LoginRepository {
  Future<APIResult<LoginResponseDTO?>> AuthenticationUser(
    LoginRequestDTO loginRequestDTO,
  ) async {
    try {
      final url = Uri.parse('${API_Constants.baseUrl}/Login/Login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginRequestDTO.toJson()),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return APIResult<LoginResponseDTO?>.fromJson(
          data,
          (jsonData) =>
              jsonData != null
                  ? LoginResponseDTO.fromJson(jsonData as Map<String, dynamic>)
                  : null,
        );
      } else {
        return APIResult<LoginResponseDTO?>(
          Success: data['Success'] ?? false,
          Message:
              data['Message'] ??
              'Lỗi với mã trạng thái: ${response.statusCode}',
          Data: null,
        );
      }
    } catch (e) {
      return APIResult<LoginResponseDTO?>(
        Success: false,
        Message: 'Lỗi không xác định: $e',
        Data: null,
      );
    }
  }

  Future<APIResult<AccountResponseDTO?>> getUserInformation(
    String UserName,
  ) async {
    try {
      final url = Uri.parse(
        '${API_Constants.baseUrl}/Login/GetUserInformation?userName=$UserName',
      );
      final response = await http.get(url);

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return APIResult<AccountResponseDTO?>.fromJson(
          data,
          (jsonData) =>
              jsonData != null
                  ? AccountResponseDTO.fromJson(
                    jsonData as Map<String, dynamic>,
                  )
                  : null,
        );
      } else {
        return APIResult<AccountResponseDTO?>(
          Success: data['Success'] ?? false,
          Message:
              data['Message'] ??
              'Lỗi với mã trạng thái: ${response.statusCode}',
          Data: null,
        );
      }
    } catch (e) {
      return APIResult<AccountResponseDTO?>(
        Success: false,
        Message: 'Lỗi không xác định: $e',
        Data: null,
      );
    }
  }
}
