import 'package:chrome_flutter/Blocs/PickListBloc/PickListBloc.dart';
import 'package:chrome_flutter/Blocs/PickListBloc/PickListEvent.dart';
import 'package:chrome_flutter/Presentation/Screens/PickListScreen/PickAndDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/ManufacturingOrderDetailBloc/ManufacturingOrderDetailBloc.dart';
import '../../../Blocs/ManufacturingOrderDetailBloc/ManufacturingOrderDetailEvent.dart';
import '../../../Blocs/ManufacturingOrderDetailBloc/ManufacturingOrderDetailState.dart';
import '../../../Blocs/PickListBloc/PickListState.dart';
import '../../../Data/Models/ManufacturingOrderDTO/ManufacturingOrderResponseDTO.dart';
import '../../Widgets/ManufacturingOrderWidget/ManufacturinOrderDetailCard.dart';

class ManufacturingOrderDetailScreen extends StatefulWidget {
  final String manufacturingOrderCode;
  final ManufacturingOrderResponseDTO manufacturingOrder;

  const ManufacturingOrderDetailScreen({
    Key? key,
    required this.manufacturingOrderCode,
    required this.manufacturingOrder,
  }) : super(key: key);

  @override
  _ManufacturingOrderDetailScreenState createState() =>
      _ManufacturingOrderDetailScreenState();
}

class _ManufacturingOrderDetailScreenState
    extends State<ManufacturingOrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Fetch manufacturing order details
      context.read<ManufacturingOrderDetailBloc>().add(
        FetchManufacturingOrderDetailEvent(
          manufacturingOrderCode: widget.manufacturingOrderCode,
        ),
      );
      // Fetch pick list data
      context.read<PickListBloc>().add(
        FetchPickAndDetailEvent(orderCode: widget.manufacturingOrderCode),
      );
    });
  }

  void _fetchData() {
    context.read<ManufacturingOrderDetailBloc>().add(
      FetchManufacturingOrderDetailEvent(
        manufacturingOrderCode: widget.manufacturingOrderCode,
      ),
    );
  }

  void _fetchDataPickList() {
    context.read<PickListBloc>().add(
      FetchPickAndDetailEvent(orderCode: widget.manufacturingOrderCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with manufacturingOrderCode and back button
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
                      '#${widget.manufacturingOrderCode}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Use BlocBuilder to check PickListBloc state
                  BlocBuilder<PickListBloc, PickListState>(
                    builder: (context, pickListState) {
                      bool shouldShowPickButton = false;

                      // Check pick list state to determine if the button should be shown
                      if (pickListState is PickLoaded) {
                        // Assuming PickListLoaded has a property like `hasPickOrder` and `pickStatusId`
                        shouldShowPickButton =
                            pickListState.pickLists != null &&
                            pickListState.pickLists.StatusId !=
                                3; // Only show if pick order exists and status is "Chưa bắt đầu"
                      }

                      return shouldShowPickButton
                          ? Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PickAndDetailScreen(
                                          orderCode:
                                              widget
                                                  .manufacturingOrder
                                                  .ManufacturingOrderCode,
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
                                'Lấy hàng',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          : const SizedBox.shrink(); // Hide button if conditions are not met
                    },
                  ),
                ],
              ),
            ),

            // List of manufacturing order details with pagination
            Expanded(
              child: BlocBuilder<
                ManufacturingOrderDetailBloc,
                ManufacturingOrderDetailState
              >(
                builder: (context, state) {
                  if (state is ManufacturingOrderDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ManufacturingOrderDetailLoaded) {
                    final manufacturingOrderDetails =
                        state.manufacturingOrderDetailResponseDTO;

                    return Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              _fetchData();
                              _fetchDataPickList(); // Refresh pick list data as well
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.all(10.0),
                              itemCount: manufacturingOrderDetails.length,
                              itemBuilder: (context, index) {
                                return ManufacturingOrderDetailCard(
                                  manufacturingOrderDetail:
                                      manufacturingOrderDetails[index],
                                  manufacturingOrder: widget.manufacturingOrder,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is ManufacturingOrderDetailErorr) {
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
                              _fetchData();
                              _fetchDataPickList(); // Retry pick list data
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
