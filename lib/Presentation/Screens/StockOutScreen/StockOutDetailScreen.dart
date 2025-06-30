import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/StockOutDetailBloc/StockOutDetailBloc.dart';
import '../../../Blocs/StockOutDetailBloc/StockOutDetailEvent.dart';
import '../../../Blocs/StockOutDetailBloc/StockOutDetailState.dart';
import '../../Widgets/StockOutWidget/StockOutDetailCard.dart';

class StockOutDetailScreen extends StatefulWidget {
  final String stockOutCode;

  const StockOutDetailScreen({Key? key, required this.stockOutCode})
    : super(key: key);

  @override
  _StockOutDetailScreenState createState() => _StockOutDetailScreenState();
}

class _StockOutDetailScreenState extends State<StockOutDetailScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StockOutDetailBloc>().add(
        FetchStockOutDetailEvent(stockOutCode: widget.stockOutCode),
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
                      '#${widget.stockOutCode}',
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
            Expanded(
              child: BlocBuilder<StockOutDetailBloc, StockOutDetailState>(
                builder: (context, state) {
                  if (state is StockOutDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is StockOutDetailLoaded) {
                    final filteredStockOutDetails = state.StockOutDetails;
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<StockOutDetailBloc>().add(
                          FetchStockOutDetailEvent(
                            stockOutCode: widget.stockOutCode,
                          ),
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: filteredStockOutDetails.length,
                        itemBuilder: (context, index) {
                          return StockOutDetailCard(
                            stockOutDetail: filteredStockOutDetails[index],
                          );
                        },
                      ),
                    );
                  } else if (state is StockOutDetailError) {
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
                              context.read<StockOutDetailBloc>().add(
                                FetchStockOutDetailEvent(
                                  stockOutCode: widget.stockOutCode,
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
