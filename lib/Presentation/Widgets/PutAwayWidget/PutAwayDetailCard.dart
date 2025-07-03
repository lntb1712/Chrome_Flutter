import 'package:flutter/material.dart';

import '../../../Data/Models/PutAwayDetailDTO/PutAwayDetailResponseDTO.dart';
import '../../Screens/PutAwayScreen/ConfirmPutAwayDetailScreen.dart';
import '../../Screens/QRScannerScreen/QRScanScreen.dart';

class PutAwayDetailCard extends StatefulWidget {
  final PutAwayDetailResponseDTO putAwayDetail;

  const PutAwayDetailCard({Key? key, required this.putAwayDetail})
    : super(key: key);

  @override
  _PutAwayDetailCardState createState() => _PutAwayDetailCardState();
}

class _PutAwayDetailCardState extends State<PutAwayDetailCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      onLongPress: () async {
        if (widget.putAwayDetail.Demand == widget.putAwayDetail.Quantity) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chi tiết cất kho đã hoàn thành'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Navigate to QRScanScreen to validate ProductCode and LotNo
        final scannedData = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRScanScreen()),
        );

        if (scannedData != null) {
          // Parse QR code data (format: ProductCode|LotNo)
          final parts = scannedData.split('|');
          if (parts.length == 2) {
            final scannedProductCode = parts[0];
            final scannedLotNo = parts[1];

            // Validate against PutAwayDetailResponseDTO
            if (scannedProductCode == widget.putAwayDetail.ProductCode &&
                scannedLotNo == widget.putAwayDetail.LotNo) {
              // QR code matches, proceed to confirmation screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ConfirmPutAwayDetailScreen(
                        putAwayDetail: widget.putAwayDetail,
                      ),
                ),
              );
            } else {
              // QR code does not match
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mã sản phẩm hoặc số lô không khớp!'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            // Invalid QR code format
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Định dạng mã QR không hợp lệ!'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Tên sản phẩm: ${widget.putAwayDetail.ProductName}",
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
            _buildInfoRow(
              Icons.code,
              "Mã sản phẩm",
              widget.putAwayDetail.ProductCode,
            ),
            _buildInfoRow(
              Icons.inventory,
              "Tên sản phẩm",
              widget.putAwayDetail.ProductName,
            ),
            _buildInfoRow(Icons.numbers, "Số lô", widget.putAwayDetail.LotNo),
            const SizedBox(height: 4),
            _buildProgressRow(_calculateProgress()),
            if (_isExpanded) ...[
              const Divider(thickness: 1, color: Colors.grey),
              _buildInfoRow(
                Icons.production_quantity_limits,
                "Số lượng yêu cầu",
                widget.putAwayDetail.Demand.toString(),
              ),
              _buildInfoRow(
                Icons.fact_check,
                "Số lượng thực tế",
                widget.putAwayDetail.Quantity.toString(),
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
    if (widget.putAwayDetail.Quantity == 0) return 0.0;
    return (widget.putAwayDetail.Quantity! / widget.putAwayDetail.Demand! * 100)
        .clamp(0, 100);
  }
}
