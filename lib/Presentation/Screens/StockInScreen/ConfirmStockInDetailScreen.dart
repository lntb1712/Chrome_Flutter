import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/QRGeneratorBloc/QRGeneratorBloc.dart';
import '../../../Blocs/QRGeneratorBloc/QRGeneratorEvent.dart';
import '../../../Blocs/QRGeneratorBloc/QRGeneratorState.dart';
import '../../../Blocs/StockInDetailBloc/StockInDetailBloc.dart';
import '../../../Blocs/StockInDetailBloc/StockInDetailEvent.dart';
import '../../../Blocs/StockInDetailBloc/StockInDetailState.dart';
import '../../../Data/Models/QRGeneratorDTO/QRGeneratorRequestDTO.dart';
import '../../../Data/Models/StockInDetailDTO/StockInDetailRequestDTO.dart';
import '../../../Data/Models/StockInDetailDTO/StockInDetailResponseDTO.dart';

class ConfirmStockInDetailScreen extends StatefulWidget {
  final StockInDetailResponseDTO stockInDetail;

  const ConfirmStockInDetailScreen({Key? key, required this.stockInDetail})
    : super(key: key);

  @override
  _ConfirmStockInDetailScreenState createState() =>
      _ConfirmStockInDetailScreenState();
}

class _ConfirmStockInDetailScreenState
    extends State<ConfirmStockInDetailScreen> {
  final TextEditingController _quantityActualController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantityActualController.text = '0.0';
  }

  @override
  void dispose() {
    _quantityActualController.dispose();
    super.dispose();
  }

  void _confirmQuantity(BuildContext context) async {
    final quantityActual = double.tryParse(_quantityActualController.text);
    if (quantityActual == null ||
        quantityActual < 0 ||
        quantityActual >
            (widget.stockInDetail.Demand! - widget.stockInDetail.Quantity!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số lượng hợp lệ'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final updatedStockInDetail = StockInDetailRequestDTO(
      StockInCode: widget.stockInDetail.StockInCode,
      ProductCode: widget.stockInDetail.ProductCode,
      Demand: widget.stockInDetail.Demand,
      Quantity: quantityActual,
    );

    context.read<StockInDetailBloc>().add(
      UpdateStockInDetailEvent(stockInDetail: updatedStockInDetail),
    );
  }

  Future<void> _generateQRCode(BuildContext context) async {
    final qrRequest = QRGeneratorRequestDTO(
      ProductCode: widget.stockInDetail.ProductCode,
      LotNo: widget.stockInDetail.Lotno,
    );
    // Thêm độ trễ nhỏ để đảm bảo backend xử lý tuần tự
    await Future.delayed(const Duration(milliseconds: 100));

    context.read<QRGeneratorBloc>().add(
      QRGenerateEvent(qrGeneratorRequestDTO: qrRequest),
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
              child: MultiBlocListener(
                listeners: [
                  BlocListener<StockInDetailBloc, StockInDetailState>(
                    listener: (context, state) async {
                      if (state is StockInDetailLoaded) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cập nhật số lượng thành công'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        final quantityActual =
                            double.tryParse(_quantityActualController.text) ??
                            0.0;
                        // Kiểm tra nếu tổng số lượng thực tế đạt QuantityIn
                        if ((widget.stockInDetail.Quantity! + quantityActual) >=
                            widget.stockInDetail.Demand!) {
                          if (quantityActual <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Lỗi: Số lượng nhận vào không hợp lệ',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                        }
                      }
                    },
                  ),
                  BlocListener<QRGeneratorBloc, QRGeneratorState>(
                    listener: (context, state) {
                      if (state is QRGenerated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${state.message}'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (state is QRGeneratorError) {
                        print('Lỗi tạo mã QR: ${state.message}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lỗi tạo QR: ${state.message}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          'Xác nhận số lượng',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _generateQRCode(context),
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
                          child: BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
                            builder: (context, state) {
                              return const Text(
                                'In QR',
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
                    _buildInfoRow(
                      'Mã nhập kho',
                      widget.stockInDetail.StockInCode,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Mã sản phẩm',
                      widget.stockInDetail.ProductCode,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Số lô', widget.stockInDetail.Lotno),

                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Số lượng dự kiến',
                      widget.stockInDetail.Demand!.toStringAsFixed(2),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Số lượng còn cần nhập',
                      (widget.stockInDetail.Demand! -
                              widget.stockInDetail.Quantity!)
                          .toStringAsFixed(2),
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
                            StockInDetailBloc,
                            StockInDetailState
                          >(
                            builder: (context, state) {
                              if (state is StockInDetailLoading) {
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
