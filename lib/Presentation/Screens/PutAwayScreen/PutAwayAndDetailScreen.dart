import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/PutAwayBloc/PutAwayBloc.dart';
import '../../../Blocs/PutAwayBloc/PutAwayEvent.dart';
import '../../../Blocs/PutAwayBloc/PutAwayState.dart';
import '../../Widgets/PutAwayWidget/PutAwayDetailCard.dart';

class PutAwayAndDetailScreen extends StatefulWidget {
  final String orderCode;

  const PutAwayAndDetailScreen({Key? key, required this.orderCode})
    : super(key: key);

  @override
  _PutAwayAndDetailScreenState createState() => _PutAwayAndDetailScreenState();
}

class _PutAwayAndDetailScreenState extends State<PutAwayAndDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PutAwayBloc>().add(
        FetchPutAwayAndDetailEvent(orderCode: widget.orderCode),
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

            // Put Away and Details
            Expanded(
              child: BlocBuilder<PutAwayBloc, PutAwayState>(
                builder: (context, state) {
                  if (state is PutAwayLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PutAwayAndDetailLoaded) {
                    final putAwayAndDetail =
                        state.putAwayResponses; // PutAwayAndDetailResponseDTO
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<PutAwayBloc>().add(
                          FetchPutAwayAndDetailEvent(
                            orderCode: widget.orderCode,
                          ),
                        );
                      },
                      child: ListView(
                        padding: const EdgeInsets.all(10.0),
                        children: [
                          // Display Put Away details
                          _buildInfoRow(
                            Icons.person,
                            "Mã cất kho",
                            putAwayAndDetail.PutAwayCode,
                          ),
                          _buildInfoRow(
                            Icons.warehouse,
                            "Kệ",
                            putAwayAndDetail.LocationCode,
                          ),
                          _buildInfoRow(
                            Icons.calendar_today,
                            "Ngày cất kho",
                            putAwayAndDetail.PutAwayDate,
                          ),

                          _buildInfoRow(
                            Icons.description,
                            "Trạng thái",
                            putAwayAndDetail.StatusName,
                          ),
                          _buildInfoRow(
                            Icons.person,
                            "Người phụ trách",
                            putAwayAndDetail.FullNameResponsible,
                          ),
                          const SizedBox(height: 10),
                          const Divider(thickness: 2, color: Colors.grey),
                          const SizedBox(height: 8),
                          // Display list of PutAwayDetailCard
                          Scrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                children:
                                    putAwayAndDetail.putAwayDetailResponseDTOs
                                        .map(
                                          (detail) => PutAwayDetailCard(
                                            putAwayDetail: detail,
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is PutAwayError) {
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
                              context.read<PutAwayBloc>().add(
                                FetchPutAwayAndDetailEvent(
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
}
