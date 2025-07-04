import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/StockTakeDetailBloc/StockTakeDetailBloc.dart';
import '../../../Blocs/StockTakeDetailBloc/StockTakeDetailEvent.dart';
import '../../../Blocs/StockTakeDetailBloc/StockTakeDetailState.dart';
import '../../../Data/Models/StockTakeDetailDTO/StockTakeDetailRequestDTO.dart';
import '../../../Data/Models/StockTakeDetailDTO/StockTakeDetailResponseDTO.dart';

class ConfirmStockTakeDetailScreen extends StatefulWidget {
  final StockTakeDetailResponseDTO stockTakeDetail;

  const ConfirmStockTakeDetailScreen({Key? key, required this.stockTakeDetail})
    : super(key: key);

  @override
  _ConfirmStockTakeDetailScreenState createState() =>
      _ConfirmStockTakeDetailScreenState();
}

class _ConfirmStockTakeDetailScreenState
    extends State<ConfirmStockTakeDetailScreen> {
  final TextEditingController _countedQuantityController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _countedQuantityController.text =
        widget.stockTakeDetail.CountedQuantity?.toStringAsFixed(2) ?? '0.0';
  }

  @override
  void dispose() {
    _countedQuantityController.dispose();
    super.dispose();
  }

  void _confirmQuantity(BuildContext context) {
    final countedQuantity = double.tryParse(_countedQuantityController.text);
    if (countedQuantity == null || countedQuantity < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số lượng hợp lệ'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final updatedStockTakeDetail = StockTakeDetailRequestDTO(
      StocktakeCode: widget.stockTakeDetail.StocktakeCode,
      ProductCode: widget.stockTakeDetail.ProductCode,
      Lotno: widget.stockTakeDetail.Lotno,
      LocationCode: widget.stockTakeDetail.LocationCode,
      Quantity: widget.stockTakeDetail.Quantity,
      CountedQuantity: countedQuantity,
    );

    context.read<StockTakeDetailBloc>().add(
      UpdateStockTakeDetailEvent(stockTakeDetail: updatedStockTakeDetail),
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
              child: BlocListener<StockTakeDetailBloc, StockTakeDetailState>(
                listener: (context, state) {
                  if (state is StockTakeDetailLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cập nhật số lượng kiểm kho thành công'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context);
                  } else if (state is StockTakeDetailError) {
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
                      'Xác nhận số lượng kiểm kho',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      'Mã kiểm kho',
                      widget.stockTakeDetail.StocktakeCode,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Mã sản phẩm',
                      widget.stockTakeDetail.ProductCode,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Tên sản phẩm',
                      widget.stockTakeDetail.ProductName,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Số lô', widget.stockTakeDetail.Lotno),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Vị trí',
                      widget.stockTakeDetail.LocationCode,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Số lượng dự kiến',
                      widget.stockTakeDetail.Quantity?.toStringAsFixed(2) ??
                          '0.0',
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _countedQuantityController,
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
                            StockTakeDetailBloc,
                            StockTakeDetailState
                          >(
                            builder: (context, state) {
                              if (state is StockTakeDetailLoading) {
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
