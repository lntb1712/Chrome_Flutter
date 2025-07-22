import 'package:flutter/material.dart';

import '../../../Data/Models/PutAwayDTO/PutAwayResponseDTO.dart';
import '../../Screens/PutAwayScreen/PutAwayDetailScreen.dart';

class PutAwayCard extends StatefulWidget {
  final PutAwayResponseDTO putAway;

  const PutAwayCard({super.key, required this.putAway});

  @override
  _PutAwayCardState createState() => _PutAwayCardState();
}

class _PutAwayCardState extends State<PutAwayCard> {
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
                (context) => PutAwayDetailScreen(
                  putAwayCode: widget.putAway.PutAwayCode,
                ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
          border: Border.all(
            color: _isExpanded ? Colors.lightBlueAccent : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${widget.putAway.PutAwayCode}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusLabel(widget.putAway.StatusId),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.person,
              "Người phụ trách",
              widget.putAway.FullNameResponsible,
            ),
            _buildInfoRow(
              Icons.location_on,
              "Vị trí",
              widget.putAway.LocationName,
            ),
            const SizedBox(height: 2),
            if (_isExpanded) ...[
              const Divider(thickness: 1, color: Colors.grey),
              _buildInfoRow(
                Icons.calendar_today,
                "Ngày cất kho",
                widget.putAway.PutAwayDate,
              ),
              _buildInfoRow(
                Icons.edit_calendar_rounded,
                "Loại lệnh",
                widget.putAway.OrderTypeCode,
              ),
              _buildInfoRow(
                Icons.edit_calendar_rounded,
                "Tên lệnh",
                widget.putAway.OrderTypeName,
              ),
              _buildInfoRow(
                Icons.update,
                "Mô tả",
                widget.putAway.PutAwayDescription,
              ),
            ],
          ],
        ),
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
            flex: 3,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          fontSize: 11,
        ),
      ),
    );
  }
}
