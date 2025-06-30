import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/StockInDetailBloc/StockInDetailBloc.dart';
import '../../../Blocs/StockInDetailBloc/StockInDetailEvent.dart';
import '../../../Blocs/StockInDetailBloc/StockInDetailState.dart';
import '../../Widgets/StockInWidget/StockInDetailCard.dart';

class StockInDetailScreen extends StatefulWidget {
  final String stockInCode;

  const StockInDetailScreen({Key? key, required this.stockInCode})
    : super(key: key);

  @override
  _StockInDetailScreenState createState() => _StockInDetailScreenState();
}

class _StockInDetailScreenState extends State<StockInDetailScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StockInDetailBloc>().add(
        FetchStockInDetailEvent(stockInCode: widget.stockInCode),
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
            // Hiển thị stockInCode và nút back
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
                      '#${widget.stockInCode}',
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

            // Danh sách chi tiết
            Expanded(
              child: BlocBuilder<StockInDetailBloc, StockInDetailState>(
                builder: (context, state) {
                  if (state is StockInDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is StockInDetailLoaded) {
                    final filteredStockInDetails = state.stockInDetail;
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<StockInDetailBloc>().add(
                          FetchStockInDetailEvent(
                            stockInCode: widget.stockInCode,
                          ),
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: filteredStockInDetails.length,
                        itemBuilder: (context, index) {
                          return StockInDetailCard(
                            stockInDetail: filteredStockInDetails[index],
                          );
                        },
                      ),
                    );
                  } else if (state is StockInDetailError) {
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
                              context.read<StockInDetailBloc>().add(
                                FetchStockInDetailEvent(
                                  stockInCode: widget.stockInCode,
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
