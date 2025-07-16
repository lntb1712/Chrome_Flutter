import 'package:flutter/material.dart';

import '../../../Data/Models/ManufacturingOrderDTO/ManufacturingOrderResponseDTO.dart';
import '../../../Data/Models/ManufacturingOrderDetailDTO/ManufacturingOrderDetailResponseDTO.dart';

class ManufacturingOrderDetailCard extends StatelessWidget {
  final ManufacturingOrderDetailResponseDTO manufacturingOrderDetail;
  final ManufacturingOrderResponseDTO manufacturingOrder;

  const ManufacturingOrderDetailCard({
    Key? key,
    required this.manufacturingOrderDetail,
    required this.manufacturingOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${manufacturingOrderDetail.ComponentCode}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.inventory_2,
            "Tên thành phần",
            manufacturingOrderDetail.ComponentName,
          ),
          _buildInfoRow(
            Icons.numbers,
            "Số lượng cần tiêu thụ",
            "${manufacturingOrderDetail.ToConsumeQuantity}",
          ),
          _buildInfoRow(
            Icons.check_circle,
            "Số lượng đã tiêu thụ",
            "${manufacturingOrderDetail.ConsumedQuantity}",
          ),
          _buildInfoRow(
            Icons.warning,
            "Tỷ lệ hao hụt",
            "${manufacturingOrderDetail.ScraptRate}%",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Colors.black54),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
