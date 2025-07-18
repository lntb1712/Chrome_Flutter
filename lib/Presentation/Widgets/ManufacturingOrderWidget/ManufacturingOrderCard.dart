import 'package:chrome_flutter/Presentation/Screens/ManufacturingOrderScreen/ManufacturingOrderDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/PickListBloc/PickListBloc.dart';
import '../../../Blocs/PickListBloc/PickListEvent.dart';
import '../../../Blocs/PickListBloc/PickListState.dart';
import '../../../Blocs/PutAwayBloc/PutAwayBloc.dart';
import '../../../Blocs/PutAwayBloc/PutAwayEvent.dart';
import '../../../Blocs/PutAwayBloc/PutAwayState.dart';
import '../../../Blocs/QRGeneratorBloc/QRGeneratorBloc.dart';
import '../../../Blocs/QRGeneratorBloc/QRGeneratorEvent.dart';
import '../../../Data/Models/ManufacturingOrderDTO/ManufacturingOrderResponseDTO.dart';
import '../../../Data/Models/QRGeneratorDTO/QRGeneratorRequestDTO.dart';
import '../../Screens/ManufacturingOrderScreen/ConfirmManufacturingOrderScreen.dart';
import '../../Screens/PutAwayScreen/PutAwayAndDetailScreen.dart';

class ManufacturingOrderCard extends StatefulWidget {
  final ManufacturingOrderResponseDTO manufacturingOrder;

  const ManufacturingOrderCard({super.key, required this.manufacturingOrder});

  @override
  _ManufacturingOrderCardState createState() => _ManufacturingOrderCardState();
}

class _ManufacturingOrderCardState extends State<ManufacturingOrderCard> {
  bool _isExpanded = false;
  bool _isFetching = false;
  String? _lastPickListErrorMessage;
  String? _lastPutAwayErrorMessage;

  // Reusable button style
  static final _buttonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    elevation: 5,
  );

  void _fetchData() {
    if (_isFetching) return;
    _isFetching = true;
    context.read<PickListBloc>().add(
      FetchPickAndDetailEvent(
        orderCode: widget.manufacturingOrder.ManufacturingOrderCode,
      ),
    );
    if (widget.manufacturingOrder.StatusId == 3) {
      context.read<PutAwayBloc>().add(
        FetchPutAwayAndDetailEvent(
          orderCode: widget.manufacturingOrder.ManufacturingOrderCode,
        ),
      );
    }
    Future.delayed(
      const Duration(milliseconds: 500),
      () => _isFetching = false,
    );
  }

  Future<void> _generateQRCode(BuildContext context) async {
    final productCode = widget.manufacturingOrder.ProductCode ?? '';
    final lotNo = widget.manufacturingOrder.Lotno ?? '';
    if (productCode.isEmpty || lotNo.isEmpty || productCode.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mã sản phẩm hoặc số lô không hợp lệ!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final qrRequest = QRGeneratorRequestDTO(
      ProductCode: productCode,
      LotNo: lotNo,
    );
    await Future.delayed(const Duration(milliseconds: 100));
    context.read<QRGeneratorBloc>().add(
      QRGenerateEvent(qrGeneratorRequestDTO: qrRequest),
    );
  }

  void _showErrorSnackBar(
    BuildContext context,
    String message,
    VoidCallback onRetry,
    String? lastErrorMessage,
    Function(String?) updateLastError,
  ) {
    if (lastErrorMessage != message) {
      updateLastError(message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(label: 'Retry', onPressed: onRetry),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
          if (_isExpanded) _fetchData();
        });
      },
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ManufacturingOrderDetailScreen(
                  manufacturingOrderCode:
                      widget.manufacturingOrder.ManufacturingOrderCode,
                  manufacturingOrder: widget.manufacturingOrder,
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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.manufacturingOrder.ManufacturingOrderCode,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusLabel(widget.manufacturingOrder.StatusId),
              ],
            ),
            const SizedBox(height: 8),

            // Always-visible Info
            _buildInfoRow(
              Icons.person,
              "Người phụ trách",
              widget.manufacturingOrder.FullNameResponsible ?? "N/A",
            ),
            _buildInfoRow(
              Icons.warehouse,
              "Kho",
              widget.manufacturingOrder.WarehouseName ?? "N/A",
            ),
            _buildInfoRow(
              Icons.inventory,
              "Sản phẩm",
              widget.manufacturingOrder.ProductName ?? "N/A",
            ),
            _buildInfoRow(
              Icons.numbers,
              "Số lượng",
              "${widget.manufacturingOrder.Quantity ?? 0}",
            ),
            _buildInfoRow(
              Icons.numbers,
              "Số lượng đã sản xuất",
              "${widget.manufacturingOrder.QuantityProduced ?? 0}",
            ),
            const SizedBox(height: 2),

            // Expanded Info
            if (_isExpanded) ...[
              const Divider(thickness: 1, color: Colors.grey),
              _buildInfoRow(
                Icons.calendar_today,
                "Ngày lập kế hoạch",
                widget.manufacturingOrder.ScheduleDate ?? "N/A",
              ),
              _buildInfoRow(
                Icons.calendar_month,
                "Hạn chót",
                widget.manufacturingOrder.Deadline ?? "N/A",
              ),
              _buildInfoRow(
                Icons.edit_calendar_rounded,
                "Loại lệnh",
                widget.manufacturingOrder.OrderTypeName ?? "N/A",
              ),
              _buildInfoRow(
                Icons.code,
                "BOM Code",
                widget.manufacturingOrder.Bomcode ?? "N/A",
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.manufacturingOrder.StatusId >= 2)
                    ElevatedButton(
                      onPressed: () => _generateQRCode(context),
                      style: _buttonStyle.copyWith(
                        backgroundColor: WidgetStatePropertyAll(Colors.black38),
                      ),
                      child: const Text(
                        'In QR',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  BlocBuilder<PickListBloc, PickListState>(
                    builder:
                        (context, state) => _buildConfirmButton(context, state),
                  ),
                  if (widget.manufacturingOrder.StatusId == 3)
                    BlocBuilder<PutAwayBloc, PutAwayState>(
                      builder:
                          (context, state) =>
                              _buildStoreGoodsButton(context, state),
                    ),
                ],
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
            child: Semantics(
              label: '$title icon',
              child: Icon(icon, size: 18, color: Colors.black54),
            ),
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
    final (statusText, statusColor) = switch (statusId) {
      1 => ("Chưa bắt đầu", Colors.grey),
      2 => ("Đang thực hiện", Colors.orange),
      3 => ("Đã hoàn thành", Colors.green),
      _ => ("Không xác định", Colors.redAccent),
    };

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

  Widget _buildConfirmButton(BuildContext context, PickListState state) {
    if (state is PickListLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else if (state is PickLoaded &&
        state.pickLists.StatusId == 3 &&
        widget.manufacturingOrder.StatusId != 3) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ConfirmManufacturingOrderScreen(
                      manufacturingOrder: widget.manufacturingOrder,
                    ),
              ),
            );
          },
          style: _buttonStyle.copyWith(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
          ),
          child: const Text(
            'Xác nhận lệnh',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      );
    } else if (state is PickListError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorSnackBar(
          context,
          state.message,
          () => context.read<PickListBloc>().add(
            FetchPickAndDetailEvent(
              orderCode: widget.manufacturingOrder.ManufacturingOrderCode,
            ),
          ),
          _lastPickListErrorMessage,
          (msg) => _lastPickListErrorMessage = msg,
        );
      });
    }
    return const SizedBox.shrink();
  }

  Widget _buildStoreGoodsButton(BuildContext context, PutAwayState state) {
    if (state is PutAwayLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else if (state is PutAwayAndDetailLoaded &&
        widget.manufacturingOrder.StatusId == 3 &&
        state.putAwayResponses.StatusId != 3) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => PutAwayAndDetailScreen(
                      orderCode:
                          widget.manufacturingOrder.ManufacturingOrderCode,
                    ),
              ),
            );
          },
          style: _buttonStyle.copyWith(
            backgroundColor: WidgetStatePropertyAll(Colors.green),
          ),
          child: const Text(
            'Cất hàng',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      );
    } else if (state is PutAwayError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorSnackBar(
          context,
          state.message,
          () => context.read<PutAwayBloc>().add(
            FetchPutAwayAndDetailEvent(
              orderCode: widget.manufacturingOrder.ManufacturingOrderCode,
            ),
          ),
          _lastPutAwayErrorMessage,
          (msg) => _lastPutAwayErrorMessage = msg,
        );
      });
    }
    return const SizedBox.shrink();
  }
}
