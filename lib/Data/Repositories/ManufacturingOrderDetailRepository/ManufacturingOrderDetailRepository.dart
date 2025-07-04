import 'dart:convert';

import 'package:chrome_flutter/Data/Models/APIResult/APIResult.dart';
import 'package:chrome_flutter/Data/Models/ManufacturingOrderDetailDTO/ManufacturingOrderDetailResponseDTO.dart';
import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/Constants/API_Constants.dart';
import '../../../Utils/SharedPreferences/TokenHelper.dart';

class ManufacturingOrderDetailRepository {
  Future<APIResult<PagedResponse<ManufacturingOrderDetailResponseDTO>>>
  GetManufacturingOrderDetails(String manufacturingOrderCode) async {
    try {
      final token = await TokenHelper.getAccessToken();
      final url =
          '${API_Constants.baseUrl}/ManufacturingOrderDetail/GetManufacturingOrderDetails?manufacturingOrderCode=$manufacturingOrderCode';

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
          PagedResponse<ManufacturingOrderDetailResponseDTO>
        >.fromJson(
          jsonResponse,
          (data) => PagedResponse<ManufacturingOrderDetailResponseDTO>.fromJson(
            data,
            (item) => ManufacturingOrderDetailResponseDTO.fromJson(item),
          ),
        );
      } else {
        final jsonResponse = json.decode(response.body);
        return new APIResult<
          PagedResponse<ManufacturingOrderDetailResponseDTO>
        >(Success: false, Message: jsonResponse['Message'], Data: null);
      }
    } catch (e) {
      return new APIResult<PagedResponse<ManufacturingOrderDetailResponseDTO>>(
        Success: false,
        Message: e.toString(),
        Data: null,
      );
    }
  }
}
