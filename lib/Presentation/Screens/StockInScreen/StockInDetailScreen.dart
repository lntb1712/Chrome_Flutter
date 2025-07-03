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
  int _currentPage = 1; // Track the current page

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StockInDetailBloc>().add(
        FetchStockInDetailEvent(
          stockInCode: widget.stockInCode,
          page: _currentPage,
        ),
      );
    });
  }

  void _goToPreviousPage(int totalPages) {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchData();
    }
  }

  void _goToNextPage(int totalPages) {
    if (_currentPage < totalPages) {
      setState(() {
        _currentPage++;
      });
      _fetchData();
    }
  }

  void _fetchData() {
    context.read<StockInDetailBloc>().add(
      FetchStockInDetailEvent(
        stockInCode: widget.stockInCode,
        page: _currentPage,
      ),
    );
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
                    final filteredStockInDetails = state.stockInDetail.Data;
                    final totalPages = state.stockInDetail.TotalPages;

                    return Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              _currentPage =
                                  1; // Reset to first page on refresh
                              _fetchData();
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
                          ),
                        ),
                        // Pagination Buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed:
                                    _currentPage > 1
                                        ? () => _goToPreviousPage(totalPages)
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  backgroundColor:
                                      _currentPage > 1
                                          ? Colors.blue
                                          : Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Trước',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                'Trang $_currentPage trên $totalPages',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ElevatedButton(
                                onPressed:
                                    _currentPage < totalPages
                                        ? () => _goToNextPage(totalPages)
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  backgroundColor:
                                      _currentPage < totalPages
                                          ? Colors.blue
                                          : Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Sau',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                              _currentPage = 1; // Reset to first page on retry
                              _fetchData();
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
