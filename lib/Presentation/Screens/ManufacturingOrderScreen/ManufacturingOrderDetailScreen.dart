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
import '../../../Data/Models/ManufacturingOrderDetailDTO/ManufacturingOrderDetailRequestDTO.dart';
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
  final List<ManufacturingOrderDetailRequestDTO> _updatedQuantities = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ManufacturingOrderDetailBloc>().add(
        FetchManufacturingOrderDetailEvent(
          manufacturingOrderCode: widget.manufacturingOrderCode,
        ),
      );
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

  void _updateQuantities() {
    if (_updatedQuantities.isNotEmpty) {
      context.read<ManufacturingOrderDetailBloc>().add(
        UpdateManufacturingOrderDetailEvent(
          manufacturingOrderDetailRequestDTO: _updatedQuantities,
        ),
      );
    }
  }

  void _onQuantityChanged(ManufacturingOrderDetailRequestDTO updatedDetail) {
    setState(() {
      _updatedQuantities.removeWhere(
        (item) => item.ComponentCode == updatedDetail.ComponentCode,
      );
      _updatedQuantities.add(updatedDetail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<
          ManufacturingOrderDetailBloc,
          ManufacturingOrderDetailState
        >(
          listener: (context, state) {
            if (state is ManufacturingOrderDetailSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
              setState(() {
                _updatedQuantities.clear();
              });
            } else if (state is ManufacturingOrderDetailErorr) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lỗi: ${state.message}'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    BlocBuilder<PickListBloc, PickListState>(
                      builder: (context, pickListState) {
                        bool shouldShowPickButton = false;
                        if (pickListState is PickLoaded) {
                          shouldShowPickButton =
                              pickListState.pickLists.StatusId != 3;
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.black38,
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'Lấy hàng',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            : const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              // Danh sách chi tiết
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
                                _fetchDataPickList();
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.all(10.0),
                                itemCount: manufacturingOrderDetails.length,
                                itemBuilder: (context, index) {
                                  return ManufacturingOrderDetailCard(
                                    manufacturingOrderDetail:
                                        manufacturingOrderDetails[index],
                                    manufacturingOrder:
                                        widget.manufacturingOrder,
                                    onQuantityChanged: _onQuantityChanged,
                                  );
                                },
                              ),
                            ),
                          ),
                          // Nút cập nhật số lượng (di chuyển xuống dưới)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 16.0,
                            ),
                            child: ElevatedButton(
                              onPressed:
                                  _updatedQuantities.isEmpty
                                      ? null
                                      : _updateQuantities,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Cập nhật số lượng',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
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
                            const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 50,
                            ),
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
                                _fetchDataPickList();
                              },
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
