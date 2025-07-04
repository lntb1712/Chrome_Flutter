import 'package:chrome_flutter/Presentation/Screens/ManufacturingOrderScreen/ManufacturingOrderDetailScreen.dart';
import 'package:chrome_flutter/Presentation/Screens/PutAwayScreen/PutAwayAndDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/PickListBloc/PickListBloc.dart';
import '../../../Blocs/PickListBloc/PickListEvent.dart';
import '../../../Blocs/PickListBloc/PickListState.dart';
import '../../../Blocs/PutAwayBloc/PutAwayBloc.dart';
import '../../../Blocs/PutAwayBloc/PutAwayEvent.dart';
import '../../../Blocs/PutAwayBloc/PutAwayState.dart';
import '../../../Data/Models/ManufacturingOrderDTO/ManufacturingOrderResponseDTO.dart';
import '../../Screens/ManufacturingOrderScreen/ConfirmManufacturingOrderScreen.dart';

class ManufacturingOrderCard extends StatefulWidget {
  final ManufacturingOrderResponseDTO manufacturingOrder;

  const ManufacturingOrderCard({super.key, required this.manufacturingOrder});

  @override
  _ManufacturingOrderCardState createState() => _ManufacturingOrderCardState();
}

class _ManufacturingOrderCardState extends State<ManufacturingOrderCard> {
  bool _isExpanded = false;
  String? _lastErrorMessage; // Track last error to prevent duplicate SnackBars

  void _fetchData() {
    context.read<PickListBloc>().add(
      FetchPickAndDetailEvent(
        orderCode: widget.manufacturingOrder.ManufacturingOrderCode,
      ),
    );
    context.read<PutAwayBloc>().add(
      FetchPutAwayAndDetailEvent(
        orderCode: widget.manufacturingOrder.ManufacturingOrderCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
          if (_isExpanded) {
            _fetchData();
          }
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
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(16),
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
                    "${widget.manufacturingOrder.ManufacturingOrderCode}",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusLabel(widget.manufacturingOrder.StatusId),
              ],
            ),
            const SizedBox(height: 12),

            /// Always-visible Info
            _buildInfoRow(
              Icons.person,
              "Người phụ trách",
              widget.manufacturingOrder.FullNameResponsible,
            ),
            _buildInfoRow(
              Icons.warehouse,
              "Kho",
              widget.manufacturingOrder.WarehouseName,
            ),
            _buildInfoRow(
              Icons.inventory,
              "Sản phẩm",
              widget.manufacturingOrder.ProductName,
            ),
            _buildInfoRow(
              Icons.numbers,
              "Số lượng",
              "${widget.manufacturingOrder.Quantity}",
            ),
            const SizedBox(height: 4),

            /// Expanded Info
            if (_isExpanded) ...[
              const Divider(thickness: 1, color: Colors.grey),
              _buildInfoRow(
                Icons.calendar_today,
                "Ngày lập kế hoạch",
                widget.manufacturingOrder.ScheduleDate,
              ),
              _buildInfoRow(
                Icons.calendar_month,
                "Hạn chót",
                widget.manufacturingOrder.Deadline,
              ),
              _buildInfoRow(
                Icons.edit_calendar_rounded,
                "Loại lệnh",
                widget.manufacturingOrder.OrderTypeName,
              ),
              _buildInfoRow(
                Icons.code,
                "BOM Code",
                widget.manufacturingOrder.Bomcode,
              ),
              // Buttons Section
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Confirm Button (based on PickList status)
                  BlocBuilder<PickListBloc, PickListState>(
                    builder: (context, pickListState) {
                      bool shouldShowConfirmButton = false;
                      bool isLoading = false;

                      if (pickListState is PickListLoading) {
                        isLoading = true;
                      } else if (pickListState is PickLoaded) {
                        shouldShowConfirmButton =
                            pickListState.pickLists != null &&
                            pickListState.pickLists.StatusId == 3 &&
                            widget.manufacturingOrder.StatusId != 3;
                      } else if (pickListState is PickListError) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_lastErrorMessage != pickListState.message) {
                            _lastErrorMessage = pickListState.message;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(pickListState.message),
                                action: SnackBarAction(
                                  label: 'Retry',
                                  onPressed:
                                      () => context.read<PickListBloc>().add(
                                        FetchPickAndDetailEvent(
                                          orderCode:
                                              widget
                                                  .manufacturingOrder
                                                  .ManufacturingOrderCode,
                                        ),
                                      ),
                                ),
                              ),
                            );
                          }
                        });
                      }

                      return isLoading
                          ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                          : shouldShowConfirmButton
                          ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            ConfirmManufacturingOrderScreen(
                                              manufacturingOrder:
                                                  widget.manufacturingOrder,
                                            ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Xác nhận lệnh',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          : const SizedBox.shrink();
                    },
                  ),
                  // Store Goods Button (based on Manufacturing Order and Putaway status)
                  BlocBuilder<PutAwayBloc, PutAwayState>(
                    builder: (context, putawayState) {
                      bool shouldShowStoreGoodsButton = false;
                      bool isLoading = false;

                      if (putawayState is PutAwayLoading) {
                        isLoading = true;
                      } else if (putawayState is PutAwayAndDetailLoaded) {
                        if (putawayState.putAwayResponses != null) {
                          shouldShowStoreGoodsButton =
                              widget.manufacturingOrder.StatusId == 3 &&
                              putawayState.putAwayResponses.StatusId != 3;
                        } else {
                          shouldShowStoreGoodsButton = false;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (_lastErrorMessage != 'Chưa hoàn thành lệnh') {
                              _lastErrorMessage = 'Chưa hoàn thành lệnh';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Chưa hoàn thành lệnh'),
                                  action: SnackBarAction(
                                    label: 'Retry',
                                    onPressed:
                                        () => context.read<PutAwayBloc>().add(
                                          FetchPutAwayAndDetailEvent(
                                            orderCode:
                                                widget
                                                    .manufacturingOrder
                                                    .ManufacturingOrderCode,
                                          ),
                                        ),
                                  ),
                                ),
                              );
                            }
                          });
                        }
                      } else if (putawayState is PutAwayError) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_lastErrorMessage != 'Chưa hoàn thành lệnh') {
                            _lastErrorMessage = 'Chưa hoàn thành lệnh';
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Chưa hoàn thành lệnh'),
                                action: SnackBarAction(
                                  label: 'Retry',
                                  onPressed:
                                      () => context.read<PutAwayBloc>().add(
                                        FetchPutAwayAndDetailEvent(
                                          orderCode:
                                              widget
                                                  .manufacturingOrder
                                                  .ManufacturingOrderCode,
                                        ),
                                      ),
                                ),
                              ),
                            );
                          }
                        });
                      }

                      return isLoading
                          ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                          : shouldShowStoreGoodsButton
                          ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PutAwayAndDetailScreen(
                                          orderCode:
                                              widget
                                                  .manufacturingOrder
                                                  .ManufacturingOrderCode,
                                        ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Cất hàng',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          : const SizedBox.shrink();
                    },
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
