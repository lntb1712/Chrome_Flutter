import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/ManufacturingOrderBloc/ManufacturingOrderBloc.dart';
import '../../../Blocs/ManufacturingOrderBloc/ManufacturingOrderEvent.dart';
import '../../../Blocs/ManufacturingOrderBloc/ManufacturingOrderState.dart';
import '../../../Data/Models/ManufacturingOrderDTO/ManufacturingOrderRequestDTO.dart';
import '../../../Data/Models/ManufacturingOrderDTO/ManufacturingOrderResponseDTO.dart';

class ConfirmManufacturingOrderScreen extends StatefulWidget {
  final ManufacturingOrderResponseDTO manufacturingOrder;

  const ConfirmManufacturingOrderScreen({
    Key? key,
    required this.manufacturingOrder,
  }) : super(key: key);

  @override
  _ConfirmManufacturingOrderScreenState createState() =>
      _ConfirmManufacturingOrderScreenState();
}

class _ConfirmManufacturingOrderScreenState
    extends State<ConfirmManufacturingOrderScreen> {
  final TextEditingController _quantityProducedController =
      TextEditingController();
  int? _selectedStatusId;

  @override
  void initState() {
    super.initState();
    _selectedStatusId = widget.manufacturingOrder.StatusId;
    _quantityProducedController.text =
        widget.manufacturingOrder.QuantityProduced.toString();
  }

  @override
  void dispose() {
    _quantityProducedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocListener<
                ManufacturingOrderBloc,
                ManufacturingOrderState
              >(
                listener: (context, state) {
                  if (state is ManufacturingOrderSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cập nhật lệnh sản xuất thành công'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context);
                  } else if (state is ManufacturingOrderError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi cập nhật: ${state.message}'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Xác nhận lệnh #${widget.manufacturingOrder.ManufacturingOrderCode}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      'Sản phẩm',
                      widget.manufacturingOrder.ProductName,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Mã sản phẩm',
                      widget.manufacturingOrder.ProductCode,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Kho',
                      widget.manufacturingOrder.WarehouseName,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Số lượng yêu cầu',
                      widget.manufacturingOrder.Quantity.toString(),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _quantityProducedController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Số lượng đã sản xuất',
                        prefixIcon: const Icon(
                          Icons.inventory,
                          color: Colors.black54,
                        ),
                        labelStyle: const TextStyle(color: Colors.black54),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => _confirmQuantity(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.black,
                            elevation: 5,
                          ),
                          child: BlocBuilder<
                            ManufacturingOrderBloc,
                            ManufacturingOrderState
                          >(
                            builder: (context, state) {
                              if (state is ManufacturingOrderLoading) {
                                return const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                );
                              }
                              return const Text(
                                'Xác nhận',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmQuantity(BuildContext context) {
    final quantityActual = int.tryParse(_quantityProducedController.text);
    if (quantityActual == null ||
        quantityActual < 0 ||
        quantityActual > widget.manufacturingOrder.Quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số lượng hợp lệ'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final updatedManufacturingOrder = ManufacturingOrderRequestDTO(
      ManufacturingOrderCode: widget.manufacturingOrder.ManufacturingOrderCode,
      OrderTypeCode: widget.manufacturingOrder.OrderTypeCode,
      ProductCode: widget.manufacturingOrder.ProductCode,
      Bomcode: widget.manufacturingOrder.Bomcode,
      BomVersion: widget.manufacturingOrder.BomVersion,
      Quantity: widget.manufacturingOrder.Quantity,
      QuantityProduced: quantityActual,
      ScheduleDate: widget.manufacturingOrder.ScheduleDate,
      Deadline: widget.manufacturingOrder.Deadline,
      Responsible: widget.manufacturingOrder.Responsible,
      StatusId: _selectedStatusId!,
      WarehouseCode: widget.manufacturingOrder.WarehouseCode,
    );

    context.read<ManufacturingOrderBloc>().add(
      UpdateManufacturingOrderEvent(
        manufacturingOrderRequestDTO: updatedManufacturingOrder,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
