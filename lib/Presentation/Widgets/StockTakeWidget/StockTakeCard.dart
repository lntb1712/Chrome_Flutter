import 'package:flutter/material.dart';

import '../../../Data/Models/StockTakeDTO/StockTakeResponseDTO.dart';
import '../../Screens/StockTakeScreen/StockTakeDetailScreen.dart';

class StockTakeCard extends StatefulWidget {
  final StockTakeResponseDTO stockTake;

  const StockTakeCard({super.key, required this.stockTake});

  @override
  _StockTakeCardState createState() => _StockTakeCardState();
}

class _StockTakeCardState extends State<StockTakeCard> {
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
                (context) => StockTakeDetailScreen(
                  stockTakeCode: widget.stockTake.StocktakeCode,
                  stockTakeResponseDTO: widget.stockTake,
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
          boxShadow: const [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.stockTake.StocktakeCode ?? "N/A",
                    style: const TextStyle(
                      fontSize: 15, // Reduced from 17
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusLabel(widget.stockTake.StatusId),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.person,
              "Người phụ trách",
              widget.stockTake.Responsible ?? "N/A",
            ),
            _buildInfoRow(
              Icons.warehouse,
              "Kho",
              widget.stockTake.WarehouseName ?? "N/A",
            ),
            const SizedBox(height: 4),
            if (_isExpanded) ...[
              const Divider(thickness: 1, color: Colors.grey),
              _buildInfoRow(
                Icons.calendar_today,
                "Ngày kiểm kho",
                widget.stockTake.StocktakeDate ?? "N/A",
              ),
              _buildInfoRow(
                Icons.edit_calendar_rounded,
                "Trạng thái",
                widget.stockTake.StatusName ?? "N/A",
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
            child: Semantics(
              label: '$title icon',
              child: Icon(icon, size: 20, color: Colors.black54),
            ),
          ),
          const SizedBox(width: 12),
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
            flex: 3,
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

  Widget _buildStatusLabel(int? statusId) {
    final (statusText, statusColor) = switch (statusId) {
      1 => ("Chưa bắt đầu", Colors.grey),
      2 => ("Đang thực hiện", Colors.orange),
      3 => ("Đã hoàn thành", Colors.green),
      _ => ("Không xác định", Colors.redAccent),
    };

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
          fontSize: 11, // Reduced from 13
        ),
      ),
    );
  }
}
