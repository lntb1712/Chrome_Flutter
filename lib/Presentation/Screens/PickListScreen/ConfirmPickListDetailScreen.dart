import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/PickListDetailBloc/PickListDetailBloc.dart';
import '../../../Blocs/PickListDetailBloc/PickListDetailEvent.dart';
import '../../../Blocs/PickListDetailBloc/PickListDetailState.dart';
import '../../../Data/Models/PickListDetailDTO/PickListDetailRequestDTO.dart';
import '../../../Data/Models/PickListDetailDTO/PickListDetailResponseDTO.dart';

class ConfirmPickListDetailScreen extends StatefulWidget {
  final PickListDetailResponseDTO pickListDetail;

  const ConfirmPickListDetailScreen({Key? key, required this.pickListDetail})
    : super(key: key);

  @override
  _ConfirmPickListDetailScreenState createState() =>
      _ConfirmPickListDetailScreenState();
}

class _ConfirmPickListDetailScreenState
    extends State<ConfirmPickListDetailScreen> {
  final TextEditingController _quantityActualController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial value of TextField to current Quantity
    _quantityActualController.text =
        widget.pickListDetail.Quantity?.toStringAsFixed(2) ?? '0.0';
  }

  @override
  void dispose() {
    _quantityActualController.dispose();
    super.dispose();
  }

  void _confirmQuantity(BuildContext context) {
    final quantityActual = double.tryParse(_quantityActualController.text);
    if (quantityActual == null ||
        quantityActual < 0 ||
        quantityActual > widget.pickListDetail.Demand!) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số lượng hợp lệ'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Create updated PickListDetailRequestDTO
    final updatedPickListDetail = PickListDetailRequestDTO(
      PickNo: widget.pickListDetail.PickNo,
      ProductCode: widget.pickListDetail.ProductCode,
      LotNo: widget.pickListDetail.LotNo,
      Demand: widget.pickListDetail.Demand,
      Quantity: quantityActual,
      LocationCode: widget.pickListDetail.LocationCode,
    );

    // Dispatch update event
    context.read<PickListDetailBloc>().add(
      UpdatePickListDetailEvent(
        pickListDetailRequestDTO: updatedPickListDetail,
      ),
    );
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
              child: BlocListener<PickListDetailBloc, PickListDetailState>(
                listener: (context, state) {
                  if (state is PickListDetailLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cập nhật số lượng pick list thành công'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context); // Navigate back on success
                  } else if (state is PickListDetailError) {
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
                    const Text(
                      'Xác nhận số lượng pick list',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow('Mã pick list', widget.pickListDetail.PickNo),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Mã sản phẩm',
                      widget.pickListDetail.ProductCode,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Số lô', widget.pickListDetail.LotNo),
                    const SizedBox(height: 12),
                    _buildInfoRow('Vị trí', widget.pickListDetail.LocationName),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Số lượng yêu cầu',
                      widget.pickListDetail.Demand?.toStringAsFixed(2) ?? '0.0',
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _quantityActualController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Số lượng thực tế',
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
                            PickListDetailBloc,
                            PickListDetailState
                          >(
                            builder: (context, state) {
                              if (state is PickListDetailLoading) {
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
