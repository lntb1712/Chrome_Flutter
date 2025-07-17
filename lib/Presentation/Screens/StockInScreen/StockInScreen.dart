import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/StockInBloc/StockInBloc.dart';
import '../../../Blocs/StockInBloc/StockInEvent.dart';
import '../../../Blocs/StockInBloc/StockInState.dart';
import '../../Widgets/SideBarMenu/SideBarMenu.dart';
import '../../Widgets/StockInWidget/StockInCard.dart';

class StockInScreen extends StatefulWidget {
  const StockInScreen({Key? key}) : super(key: key);

  @override
  _StockInScreenState createState() => _StockInScreenState();
}

class _StockInScreenState extends State<StockInScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1; // Track the current page

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StockInBloc>().add(FetchStockInEvent(page: _currentPage));
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      _searchController.clear();
      _currentPage = 1; // Reset to first page when toggling search
      if (!_isSearching) {
        context.read<StockInBloc>().add(FetchStockInEvent(page: _currentPage));
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
      context.read<StockInBloc>().add(
        FetchStockInFilteredEvent(
          textToSearch: _searchController.text,
          page: _currentPage,
        ),
      );
    } else {
      context.read<StockInBloc>().add(FetchStockInEvent(page: _currentPage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarMenu(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 30, color: Colors.white),
          tooltip: 'Mở menu',
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 6,
        shadowColor: Colors.black45,
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Tìm kiếm nhập kho...",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    _currentPage = 1; // Reset to first page on search
                    context.read<StockInBloc>().add(
                      FetchStockInFilteredEvent(
                        textToSearch: value,
                        page: _currentPage,
                      ),
                    );
                  },
                )
                : const Text(
                  'Nhập kho',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<StockInBloc, StockInState>(
                builder: (context, state) {
                  if (state is StockInLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is StockInLoaded) {
                    final filteredStockIns = state.stockIn;
                    final totalPages = state.stockIn.TotalPages;

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
                              itemCount: filteredStockIns.Data.length,
                              itemBuilder: (context, index) {
                                return StockInCard(
                                  stockIn: filteredStockIns.Data[index],
                                );
                              },
                            ),
                          ),
                        ),
                        // Pagination Buttons
                        if (totalPages > 1)
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
