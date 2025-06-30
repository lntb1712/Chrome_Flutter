import 'package:flutter/material.dart';

import '../../../Data/Models/StockOutDTO/StockOutResponseDTO.dart';
import '../../Screens/StockOutScreen/StockOutDetailScreen.dart';

class StockOutCard extends StatefulWidget {
  final StockOutResponseDTO stockOut;

  const StockOutCard({super.key, required this.stockOut});

  @override
  _StockOutCardState createState() => _StockOutCardState();
}

class _StockOutCardState extends State<StockOutCard> {
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
                (context) => StockOutDetailScreen(
                  stockOutCode: widget.stockOut.StockOutCode,
                ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(16),
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
                    "Mã xuất kho: ${widget.stockOut.StockOutCode}",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusLabel(widget.stockOut.StatusId),
              ],
            ),
            const SizedBox(height: 12),

            /// Always-visible Info
            _buildInfoRow(
              Icons.person,
              "Khách hàng",
              widget.stockOut.CustomerName,
            ),
            _buildInfoRow(
              Icons.warehouse,
              "Kho",
              widget.stockOut.WarehouseName,
            ),
            const SizedBox(height: 4),

            /// Expanded Info
            if (_isExpanded) ...[
              const Divider(thickness: 1, color: Colors.grey),
              _buildInfoRow(
                Icons.calendar_today,
                "Ngày xuất",
                widget.stockOut.StockOutDate,
              ),
              _buildInfoRow(
                Icons.edit_calendar_rounded,
                "Loại lệnh",
                widget.stockOut.OrderTypeCode,
              ),
              _buildInfoRow(
                Icons.edit_calendar_rounded,
                "Tên lệnh",
                widget.stockOut.OrderTypeName,
              ),
              _buildInfoRow(
                Icons.update,
                "Mô tả",
                widget.stockOut.StockOutDescription,
              ),
              _buildInfoRow(
                Icons.person,
                "Người phụ trách",
                widget.stockOut.FullNameResponsible,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.black54),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          fontSize: 13,
        ),
      ),
    );
  }
}
