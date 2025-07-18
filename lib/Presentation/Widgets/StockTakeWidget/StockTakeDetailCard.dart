import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/StockTakeBloc/StockTakeBloc.dart';
import '../../../Blocs/StockTakeBloc/StockTakeState.dart';
import '../../../Data/Models/StockTakeDetailDTO/StockTakeDetailResponseDTO.dart';
import '../../Screens/QRScannerScreen/QRScanScreen.dart';
import '../../Screens/StockTakeScreen/ConfirmStockTakeDetailScreen.dart';

class StockTakeDetailCard extends StatefulWidget {
  final StockTakeDetailResponseDTO stockTakeDetail;
  final String stockTakeCode;

  const StockTakeDetailCard({
    super.key,
    required this.stockTakeDetail,
    required this.stockTakeCode,
  });

  @override
  _StockTakeDetailCardState createState() => _StockTakeDetailCardState();
}

class _StockTakeDetailCardState extends State<StockTakeDetailCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockTakeBloc, StockTakeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          onLongPress: () async {
            if (widget.stockTakeDetail.Quantity ==
                widget.stockTakeDetail.CountedQuantity) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chi tiết kiểm kho đã hoàn thành'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
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

                if (scannedProductCode == widget.stockTakeDetail.ProductCode &&
                    scannedLotNo == widget.stockTakeDetail.Lotno) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ConfirmStockTakeDetailScreen(
                            stockTakeDetail: widget.stockTakeDetail,
                          ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mã sản phẩm hoặc số lô không khớp!'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Định dạng mã QR không hợp lệ!'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
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
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(
                color:
                    _isExpanded ? Colors.lightBlueAccent : Colors.transparent,
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
                        widget.stockTakeDetail.ProductName ?? "N/A",
                        style: const TextStyle(
                          fontSize: 15, // Reduced from 17
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
                  Icons.numbers,
                  "Số lô",
                  widget.stockTakeDetail.Lotno ?? "N/A",
                ),
                _buildInfoRow(
                  Icons.production_quantity_limits,
                  "Số lượng cần kiểm",
                  widget.stockTakeDetail.Quantity?.toStringAsFixed(2) ?? "0.00",
                ),
                _buildInfoRow(
                  Icons.fact_check,
                  "Số lượng thực tế",
                  widget.stockTakeDetail.CountedQuantity?.toStringAsFixed(2) ??
                      "0.00",
                ),
                _buildInfoRow(
                  Icons.location_on,
                  "Vị trí",
                  widget.stockTakeDetail.LocationCode ?? "N/A",
                ),
                const SizedBox(height: 4),
                _buildProgressRow(_calculateProgress()),
                if (_isExpanded) ...[
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildInfoRow(
                    Icons.move_down,
                    "Mã kiểm kho",
                    widget.stockTakeDetail.StocktakeCode ?? "N/A",
                  ),
                ],
              ],
            ),
          ),
        );
      },
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
            flex: 4,
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
              fontSize: 12, // Reduced from 14
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateProgress() {
    final quantity = widget.stockTakeDetail.Quantity;
    final countedQuantity = widget.stockTakeDetail.CountedQuantity;
    if (quantity == null || countedQuantity == null || quantity == 0)
      return 0.0;
    return (countedQuantity / quantity * 100).clamp(0, 100);
  }
}
