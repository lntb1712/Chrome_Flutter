import 'package:chrome_flutter/Data/Models/TransferDTO/TransferResponseDTO.dart';
import 'package:chrome_flutter/Presentation/Screens/PutAwayScreen/PutAwayAndDetailScreen.dart';
import 'package:chrome_flutter/Utils/SharedPreferences/UserNameHelper.dart';
import 'package:flutter/material.dart';

import '../../../Data/Models/TransferDetailDTO/TransferDetailResponseDTO.dart';
import '../../Screens/PickListScreen/PickAndDetailScreen.dart';

class TransferDetailCard extends StatefulWidget {
  final TransferDetailResponseDTO transferDetail;
  final TransferResponseDTO transferResponseDTO;

  const TransferDetailCard({
    Key? key,
    required this.transferDetail,
    required this.transferResponseDTO,
  }) : super(key: key);

  @override
  _TransferDetailCardState createState() => _TransferDetailCardState();
}

class _TransferDetailCardState extends State<TransferDetailCard> {
  bool _isExpanded = false;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    _userName = await UserNameHelper.getUserName();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _userName == null
        ? const Center(child: CircularProgressIndicator())
        : GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
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
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.transferDetail.ProductName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (widget.transferResponseDTO.FromResponsible ==
                            _userName) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PickAndDetailScreen(
                                    orderCode:
                                        widget.transferDetail.TransferCode,
                                  ),
                            ),
                          );
                        } else if (widget.transferResponseDTO.ToResponsible ==
                            _userName) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PutAwayAndDetailScreen(
                                    orderCode:
                                        widget.transferDetail.TransferCode,
                                  ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.black38,
                        elevation: 5,
                      ),
                      child: Text(
                        widget.transferResponseDTO.FromResponsible == _userName
                            ? 'Lấy hàng'
                            : widget.transferResponseDTO.ToResponsible ==
                                _userName
                            ? 'Cất hàng'
                            : '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                /// Always-visible Info
                _buildInfoRow(
                  Icons.code,
                  "Mã sản phẩm",
                  widget.transferDetail.ProductCode,
                ),
                _buildInfoRow(
                  Icons.inventory,
                  "Tên sản phẩm",
                  widget.transferDetail.ProductName,
                ),
                _buildInfoRow(
                  Icons.numbers,
                  "Số lượng yêu cầu",
                  widget.transferDetail.Demand?.toString() ?? '0',
                ),
                const SizedBox(height: 4),
                _buildProgressRow(_calculateProgress()),

                /// Expanded Info
                if (_isExpanded) ...[
                  const Divider(thickness: 1, color: Colors.grey),

                  _buildInfoRow(
                    Icons.output,
                    "Số lượng xuất",
                    widget.transferDetail.QuantityOutBounded?.toString() ?? '0',
                  ),
                  _buildInfoRow(
                    Icons.input,
                    "Số lượng nhập",
                    widget.transferDetail.QuantityInBounded?.toString() ?? '0',
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
    final demand = widget.transferDetail.Demand ?? 0;
    if (demand == 0) return 0.0;
    final quantityIn = widget.transferDetail.QuantityInBounded ?? 0;
    final quantityOut = widget.transferDetail.QuantityOutBounded ?? 0;
    final quantity = quantityIn > quantityOut ? quantityIn : quantityOut;
    return (quantity / demand * 100).clamp(0, 100);
  }
}
