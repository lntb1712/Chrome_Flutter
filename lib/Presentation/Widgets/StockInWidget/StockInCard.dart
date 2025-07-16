import 'package:flutter/material.dart';

import '../../../Data/Models/StockInDTO/StockInResponseDTO.dart';
import '../../Screens/StockInScreen/StockInDetailScreen.dart';

class StockInCard extends StatefulWidget {
  final StockInResponseDTO stockIn;

  const StockInCard({super.key, required this.stockIn});

  @override
  _StockInCardState createState() => _StockInCardState();
}

class _StockInCardState extends State<StockInCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => StockInDetailScreen(
                  stockInCode: widget.stockIn.StockInCode,
                ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        // Reduced from 8, 12
        padding: const EdgeInsets.all(12),
        // Reduced from 16
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: _isExpanded ? Colors.lightBlueAccent : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${widget.stockIn.StockInCode}",
                    style: const TextStyle(
                      fontSize: 14, // Reduced from 17
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusLabel(widget.stockIn.StatusId),
              ],
            ),
            const SizedBox(height: 8), // Reduced from 12
            /// Always-visible Info
            _buildInfoRow(
              Icons.person,
              "Nhà cung cấp",
              widget.stockIn.SupplierName,
            ),
            _buildInfoRow(Icons.warehouse, "Kho", widget.stockIn.WarehouseName),
            const SizedBox(height: 2), // Reduced from 4
            /// Expanded Info
            if (_isExpanded) ...[
              const Divider(thickness: 1, color: Colors.grey),
              _buildInfoRow(
                Icons.calendar_today,
                "Ngày nhập",
                widget.stockIn.OrderDeadLine,
              ),
              _buildInfoRow(
                Icons.edit_calendar_rounded,
                "Loại lệnh",
                widget.stockIn.OrderTypeCode,
              ),
              _buildInfoRow(
                Icons.edit_calendar_rounded,
                "Tên lệnh",
                widget.stockIn.OrderTypeName,
              ),
              _buildInfoRow(
                Icons.update,
                "Mô tả",
                widget.stockIn.StockInDescription!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced from 6.0
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6), // Reduced from 8
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.black54,
            ), // Reduced from 20
          ),
          const SizedBox(width: 8), // Reduced from 12
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontSize: 13, // Reduced from 15
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              // Reduced from 15
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusLabel(int statusId) {
    String statusText;
    Color statusColor;

    switch (statusId) {
      case 1:
        statusText = "Chưa bắt đầu";
        statusColor = Colors.grey;
        break;
      case 2:
        statusText = "Đang thực hiện";
        statusColor = Colors.orange;
        break;
      case 3:
        statusText = "Đã hoàn thành";
        statusColor = Colors.green;
        break;
      default:
        statusText = "Không xác định";
        statusColor = Colors.redAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      // Reduced from 12, 6
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.w600,
          fontSize: 11, // Reduced from 13
        ),
      ),
    );
  }
}
