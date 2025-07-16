import 'package:chrome_flutter/Presentation/Screens/PickListScreen/ConfirmPickListDetailScreen.dart';
import 'package:flutter/material.dart';

import '../../../Data/Models/PickListDetailDTO/PickListDetailResponseDTO.dart';
import '../../Screens/QRScannerScreen/QRScanScreen.dart';

class PickListDetailCard extends StatefulWidget {
  final PickListDetailResponseDTO pickListDetail;

  const PickListDetailCard({Key? key, required this.pickListDetail})
    : super(key: key);

  @override
  _PickListDetailCardState createState() => _PickListDetailCardState();
}

class _PickListDetailCardState extends State<PickListDetailCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      onLongPress: () async {
        if (widget.pickListDetail.Demand == widget.pickListDetail.Quantity) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chi tiết xếp kho đã hoàn thành'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final scannedData = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRScanScreen()),
        );

        if (scannedData != null) {
          final parts = scannedData.split('|');
          if (parts.length == 2) {
            final scannedProductCode = parts[0];
            final scannedLotNo = parts[1];

            if (scannedProductCode == widget.pickListDetail.ProductCode &&
                scannedLotNo == widget.pickListDetail.LotNo) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ConfirmPickListDetailScreen(
                        pickListDetail: widget.pickListDetail,
                      ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mã sản phẩm hoặc số lô không khớp!'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
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
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${widget.pickListDetail.ProductName}",
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

            /// Always-visible Info
            _buildInfoRow(
              Icons.code,
              "Mã sản phẩm",
              widget.pickListDetail.ProductCode,
            ),
            _buildInfoRow(
              Icons.inventory,
              "Tên sản phẩm",
              widget.pickListDetail.ProductName,
            ),
            _buildInfoRow(Icons.numbers, "Số lô", widget.pickListDetail.LotNo),
            _buildInfoRow(
              Icons.location_on,
              "Vị trí",
              widget.pickListDetail.LocationName,
            ),
            const SizedBox(height: 2),
            _buildProgressRow(_calculateProgress()),

            /// Expanded Info
            if (_isExpanded) ...[
              const Divider(thickness: 1, color: Colors.grey),
              _buildInfoRow(
                Icons.production_quantity_limits,
                "Số lượng yêu cầu",
                widget.pickListDetail.Demand.toString(),
              ),
              _buildInfoRow(
                Icons.fact_check,
                "Số lượng thực tế",
                widget.pickListDetail.Quantity.toString(),
              ),
              _buildInfoRow(
                Icons.location_city,
                "Mã vị trí",
                widget.pickListDetail.LocationCode,
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
            flex: 5,
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

  Widget _buildProgressRow(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${progress.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateProgress() {
    if (widget.pickListDetail.Demand == 0) return 0.0;
    return (widget.pickListDetail.Quantity! /
            widget.pickListDetail.Demand! *
            100)
        .clamp(0, 100);
  }
}
