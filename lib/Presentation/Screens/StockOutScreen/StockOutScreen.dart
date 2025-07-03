import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/StockOutBloc/StockOutBloc.dart';
import '../../../Blocs/StockOutBloc/StockOutEvent.dart';
import '../../../Blocs/StockOutBloc/StockOutState.dart';
import '../../Widgets/SideBarMenu/SideBarMenu.dart';
import '../../Widgets/StockOutWidget/StockOutCard.dart';

class StockOutScreen extends StatefulWidget {
  const StockOutScreen({Key? key}) : super(key: key);

  @override
  _StockOutScreenState createState() => _StockOutScreenState();
}

class _StockOutScreenState extends State<StockOutScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1; // Track the current page

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StockOutBloc>().add(FetchStockOutEvent(page: _currentPage));
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      _searchController.clear();
      _currentPage = 1; // Reset to first page when toggling search
      if (!_isSearching) {
        context.read<StockOutBloc>().add(
          FetchStockOutEvent(page: _currentPage),
        );
      }
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
    if (_isSearching) {
      context.read<StockOutBloc>().add(
        FetchStockOutFilteredEvent(
          textToSearch: _searchController.text,
          page: _currentPage,
        ),
      );
    } else {
      context.read<StockOutBloc>().add(FetchStockOutEvent(page: _currentPage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarMenu(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 30, color: Colors.black),
          tooltip: 'Mở menu',
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Tìm kiếm xuất kho...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    _currentPage = 1; // Reset to first page on search
                    context.read<StockOutBloc>().add(
                      FetchStockOutFilteredEvent(
                        textToSearch: value,
                        page: _currentPage,
                      ),
                    );
                  },
                )
                : const Text(
                  'Xuất kho',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            tooltip: _isSearching ? 'Đóng tìm kiếm' : 'Tìm kiếm',
            onPressed: _toggleSearch,
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<StockOutBloc, StockOutState>(
                builder: (context, state) {
                  if (state is StockOutLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is StockOutLoaded) {
                    final filteredStockOuts = state.stockOuts;
                    final totalPages = state.stockOuts.TotalPages;

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
                              itemCount: filteredStockOuts.Data.length,
                              itemBuilder: (context, index) {
                                return StockOutCard(
                                  stockOut: filteredStockOuts.Data[index],
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
