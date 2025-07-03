import 'package:flutter/material.dart';

import '../../../Data/Models/TransferDTO/TransferResponseDTO.dart';
import '../../Screens/TransferScreen/TransferDetailScreen.dart';

class TransferCard extends StatefulWidget {
  final TransferResponseDTO transfer;

  const TransferCard({super.key, required this.transfer});

  @override
  _TransferCardState createState() => _TransferCardState();
}

class _TransferCardState extends State<TransferCard> {
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
                (context) => TransferDetailScreen(
                  transferCode: widget.transfer.TransferCode,
                  transfer: widget.transfer,
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
                    "${widget.transfer.TransferCode}",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusLabel(widget.transfer.StatusId),
              ],
            ),
            const SizedBox(height: 12),

            /// Always-visible Info
            _buildInfoRow(
              Icons.person,
              "Người phụ trách (Đi)",
              widget.transfer.FullNameFromResponsible,
            ),
            _buildInfoRow(
              Icons.person,
              "Người phụ trách (Đến)",
              widget.transfer.FullNameToResponsible,
            ),
            _buildInfoRow(
              Icons.warehouse,
              "Kho nguồn",
              widget.transfer.FromWarehouseName,
            ),
            _buildInfoRow(
              Icons.warehouse,
              "Kho đích",
              widget.transfer.ToWarehouseName,
            ),
            const SizedBox(height: 4),

            /// Expanded Info
            if (_isExpanded) ...[
              const Divider(thickness: 1, color: Colors.grey),
              _buildInfoRow(
                Icons.calendar_today,
                "Ngày chuyển",
                widget.transfer.TransferDate,
              ),
              _buildInfoRow(
                Icons.edit_calendar_rounded,
                "Loại lệnh",
                widget.transfer.OrderTypeName,
              ),
              _buildInfoRow(
                Icons.description,
                "Mô tả",
                widget.transfer.TransferDescription,
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
            child: Icon(icon, size: 16, color: Colors.black54),
          ),
          const SizedBox(width: 12),
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
