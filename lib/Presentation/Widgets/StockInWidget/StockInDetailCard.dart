import 'package:flutter/material.dart';

import '../../../Data/Models/StockInDetailDTO/StockInDetailResponseDTO.dart';
import '../../Screens/StockInScreen/ConfirmStockInDetailScreen.dart';

class StockInDetailCard extends StatefulWidget {
  final StockInDetailResponseDTO stockInDetail;

  const StockInDetailCard({Key? key, required this.stockInDetail})
    : super(key: key);

  @override
  _StockInDetailCardState createState() => _StockInDetailCardState();
}

class _StockInDetailCardState extends State<StockInDetailCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      onLongPress: () {
        widget.stockInDetail.Demand == widget.stockInDetail.Quantity
            ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Chi tiết nhập kho đã hoàn thành'),
                backgroundColor: Colors.red,
              ),
            )
            : Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ConfirmStockInDetailScreen(
                      stockInDetail: widget.stockInDetail,
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
                    "${widget.stockInDetail.ProductName}",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Always-visible Info
            _buildInfoRow(
              Icons.code,
              "Mã sản phẩm",
              widget.stockInDetail.ProductCode,
            ),
            _buildInfoRow(
              Icons.inventory,
              "Tên sản phẩm",
              widget.stockInDetail.ProductName,
            ),
            _buildInfoRow(Icons.numbers, "Số lô", widget.stockInDetail.Lotno),
            const SizedBox(height: 4),
            _buildProgressRow(_calculateProgress()),

            /// Expanded Info
            if (_isExpanded) ...[
              const Divider(thickness: 1, color: Colors.grey),
              _buildInfoRow(
                Icons.production_quantity_limits,
                "Số lượng nhập",
                widget.stockInDetail.Demand.toString(),
              ),
              _buildInfoRow(
                Icons.fact_check,
                "Số lượng thực tế",
                widget.stockInDetail.Quantity.toString(),
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
            flex: 4,
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
            flex: 5,
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

  Widget _buildProgressRow(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 100 ? Colors.green : Colors.lightBlueAccent,
                ),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${progress.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateProgress() {
    // Tính phần trăm tiến độ dựa trên QuantityIn và QuantityActual
    if (widget.stockInDetail.Quantity == 0) return 0.0;
    return (widget.stockInDetail.Quantity! / widget.stockInDetail.Demand! * 100)
        .clamp(0, 100);
  }
}
