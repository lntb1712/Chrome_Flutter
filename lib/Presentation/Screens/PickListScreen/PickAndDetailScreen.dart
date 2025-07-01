import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/PickListBloc/PickListBloc.dart';
import '../../../Blocs/PickListBloc/PickListEvent.dart';
import '../../../Blocs/PickListBloc/PickListState.dart';
import '../../Widgets/PickListWidget/PickListDetailCard.dart';

class PickAndDetailScreen extends StatefulWidget {
  final String orderCode;

  const PickAndDetailScreen({Key? key, required this.orderCode})
    : super(key: key);

  @override
  _PickAndDetailScreenState createState() => _PickAndDetailScreenState();
}

class _PickAndDetailScreenState extends State<PickAndDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PickListBloc>().add(
        FetchPickAndDetailEvent(orderCode: widget.orderCode),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with order code and back button
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: Colors.black,
                    ),
                    tooltip: 'Quay lại',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '#${widget.orderCode}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Pick List and Details
            Expanded(
              child: BlocBuilder<PickListBloc, PickListState>(
                builder: (context, state) {
                  if (state is PickListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PickLoaded) {
                    final pickAndDetail =
                        state.pickLists; // PickAndDetailResponseDTO
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<PickListBloc>().add(
                          FetchPickAndDetailEvent(orderCode: widget.orderCode),
                        );
                      },
                      child: ListView(
                        padding: const EdgeInsets.all(10.0),
                        children: [
                          // Display PickListCard at the top
                          _buildInfoRow(
                            Icons.person,
                            "Mã lấy hàng",
                            pickAndDetail.PickNo,
                          ),
                          _buildInfoRow(
                            Icons.warehouse,
                            "Kho",
                            pickAndDetail.WarehouseName,
                          ),
                          _buildInfoRow(
                            Icons.calendar_today,
                            "Ngày pick",
                            pickAndDetail.PickDate,
                          ),
                          _buildInfoRow(
                            Icons.edit_calendar_rounded,
                            "Mã giữ hàng",
                            pickAndDetail.ReservationCode,
                          ),
                          _buildInfoRow(
                            Icons.description,
                            "Trạng thái",
                            pickAndDetail.StatusName,
                          ),
                          const SizedBox(height: 10),
                          const Divider(thickness: 2, color: Colors.grey),
                          const SizedBox(height: 8),
                          // Display list of PickListDetailCard
                          Scrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                children:
                                    pickAndDetail.pickListDetailResponseDTOs
                                        .map(
                                          (detail) => PickListDetailCard(
                                            pickListDetail: detail,
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is PickListError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 50),
                          const SizedBox(height: 10),
                          Text(
                            'Lỗi: ${state.message}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              context.read<PickListBloc>().add(
                                FetchPickAndDetailEvent(
                                  orderCode: widget.orderCode,
                                ),
                              );
                            },

                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 50),
                        SizedBox(height: 10),
                        Text(
                          'Lỗi khi tải dữ liệu!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoRow(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
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
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
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
