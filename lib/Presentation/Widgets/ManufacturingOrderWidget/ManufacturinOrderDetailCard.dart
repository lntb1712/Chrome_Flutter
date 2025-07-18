import 'package:flutter/material.dart';

import '../../../Data/Models/ManufacturingOrderDTO/ManufacturingOrderResponseDTO.dart';
import '../../../Data/Models/ManufacturingOrderDetailDTO/ManufacturingOrderDetailRequestDTO.dart';
import '../../../Data/Models/ManufacturingOrderDetailDTO/ManufacturingOrderDetailResponseDTO.dart';

class ManufacturingOrderDetailCard extends StatefulWidget {
  final ManufacturingOrderDetailResponseDTO manufacturingOrderDetail;
  final ManufacturingOrderResponseDTO manufacturingOrder;
  final Function(ManufacturingOrderDetailRequestDTO)? onQuantityChanged;

  const ManufacturingOrderDetailCard({
    Key? key,
    required this.manufacturingOrderDetail,
    required this.manufacturingOrder,
    this.onQuantityChanged,
  }) : super(key: key);

  @override
  _ManufacturingOrderDetailCardState createState() =>
      _ManufacturingOrderDetailCardState();
}

class _ManufacturingOrderDetailCardState
    extends State<ManufacturingOrderDetailCard> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantityController.text =
        widget.manufacturingOrderDetail.ConsumedQuantity.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

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
                  "${widget.manufacturingOrderDetail.ComponentCode}",
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
            widget.manufacturingOrderDetail.ComponentName ?? 'N/A',
          ),
          _buildInfoRow(
            Icons.numbers,
            "Số lượng cần tiêu thụ",
            "${widget.manufacturingOrderDetail.ToConsumeQuantity ?? 0}",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  flex: 4,
                  child: Text(
                    "Số lượng đã tiêu thụ:",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                    decoration: InputDecoration(
                      hintText: 'Nhập số lượng',
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      final parsedValue = double.tryParse(value) ?? 0;
                      final maxQuantity =
                          widget.manufacturingOrderDetail.ToConsumeQuantity ??
                          0;
                      if (parsedValue >= 0 && parsedValue <= maxQuantity) {
                        if (widget.onQuantityChanged != null) {
                          widget.onQuantityChanged!(
                            ManufacturingOrderDetailRequestDTO(
                              ManufacturingOrderCode:
                                  widget
                                      .manufacturingOrder
                                      .ManufacturingOrderCode,
                              ComponentCode:
                                  widget.manufacturingOrderDetail.ComponentCode,
                              ConsumedQuantity: parsedValue,
                              ScraptRate:
                                  widget.manufacturingOrderDetail.ScraptRate,
                              ToConsumeQuantity:
                                  widget
                                      .manufacturingOrderDetail
                                      .ToConsumeQuantity,
                            ),
                          );
                        }
                      } else {
                        setState(() {
                          _quantityController.text =
                              widget.manufacturingOrderDetail.ConsumedQuantity
                                  ?.toString() ??
                              '0';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Số lượng không hợp lệ!'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          _buildInfoRow(
            Icons.warning,
            "Tỷ lệ hao hụt",
            "${widget.manufacturingOrderDetail.ScraptRate ?? 0}%",
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
