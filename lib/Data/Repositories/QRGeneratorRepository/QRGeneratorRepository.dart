import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/QRGeneratorDTO/QRGeneratorRequestDTO.dart';
import 'package:chrome_flutter/Data/Models/QRGeneratorDTO/QRGeneratorResponseDTO.dart';
import 'package:chrome_flutter/Utils/Constants/API_Constants.dart';
import 'package:http/http.dart' as http;

class QRGeneratorRepository {
  Future<APIResult<QRGeneratorResponseDTO>> GeneratorQRCode(
    QRGeneratorRequestDTO qrGeneratorRequestDTO,
  ) async {
    final url = Uri.parse(
      '${API_Constants.baseUrl}/QRGenerator/GeneratorQRCode',
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(qrGeneratorRequestDTO.toJson()),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return APIResult<QRGeneratorResponseDTO>.fromJson(
        jsonResponse,
        (data) => QRGeneratorResponseDTO.fromJson(data),
      );
    } else {
      final jsonResponse = json.decode(response.body);
      return new APIResult<QRGeneratorResponseDTO>(
        Success: false,
        Message: jsonResponse['Message'],
        Data: null,
      );
    }
  }
}
