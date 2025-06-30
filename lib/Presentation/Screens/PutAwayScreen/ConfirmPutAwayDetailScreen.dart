import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/PutAwayDetailBloc/PutAwayDetailBloc.dart';
import '../../../Blocs/PutAwayDetailBloc/PutAwayDetailEvent.dart';
import '../../../Blocs/PutAwayDetailBloc/PutAwayDetailState.dart';
import '../../../Data/Models/PutAwayDetailDTO/PutAwayDetailRequestDTO.dart';
import '../../../Data/Models/PutAwayDetailDTO/PutAwayDetailResponseDTO.dart';

class ConfirmPutAwayDetailScreen extends StatefulWidget {
  final PutAwayDetailResponseDTO putAwayDetail;

  const ConfirmPutAwayDetailScreen({Key? key, required this.putAwayDetail})
    : super(key: key);

  @override
  _ConfirmPutAwayDetailScreenState createState() =>
      _ConfirmPutAwayDetailScreenState();
}

class _ConfirmPutAwayDetailScreenState
    extends State<ConfirmPutAwayDetailScreen> {
  final TextEditingController _quantityActualController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Đặt giá trị ban đầu của TextField là Quantity hiện tại
    _quantityActualController.text =
        widget.putAwayDetail.Quantity?.toStringAsFixed(2) ?? '0.0';
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
        quantityActual > widget.putAwayDetail.Demand!) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số lượng hợp lệ'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Double-check: Hiển thị dialog xác nhận

    // Gửi sự kiện cập nhật nếu người dùng xác nhận
    final updatedPutAwayDetail = PutAwayDetailRequestDTO(
      PutAwayCode: widget.putAwayDetail.PutAwayCode,
      ProductCode: widget.putAwayDetail.ProductCode,
      LotNo: widget.putAwayDetail.LotNo,
      Demand: widget.putAwayDetail.Demand,
      Quantity: quantityActual,
    );

    context.read<PutAwayDetailBloc>().add(
      UpdatePutAwayDetail(putAwayDetailRequestDTO: updatedPutAwayDetail),
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
              child: BlocListener<PutAwayDetailBloc, PutAwayDetailState>(
                listener: (context, state) {
                  if (state is PutAwayDetailLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cập nhật số lượng xếp kho thành công'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(
                      context,
                    ); // Quay lại sau khi cập nhật thành công
                  } else if (state is PutAwayDetailError) {
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
                      'Xác nhận số lượng xếp kho',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      'Mã xếp kho',
                      widget.putAwayDetail.PutAwayCode ?? '',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Mã sản phẩm',
                      widget.putAwayDetail.ProductCode ?? '',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Số lô', widget.putAwayDetail.LotNo ?? ''),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Số lượng yêu cầu',
                      widget.putAwayDetail.Demand?.toStringAsFixed(2) ?? '0.0',
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
                            PutAwayDetailBloc,
                            PutAwayDetailState
                          >(
                            builder: (context, state) {
                              if (state is PutAwayDetailLoading) {
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
