import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/StockTakeBloc/StockTakeBloc.dart';
import '../../../Blocs/StockTakeBloc/StockTakeEvent.dart';
import '../../../Blocs/StockTakeBloc/StockTakeState.dart';
import '../../Widgets/SideBarMenu/SideBarMenu.dart';
import '../../Widgets/StockTakeWidget/StockTakeCard.dart';

class StockTakeScreen extends StatefulWidget {
  const StockTakeScreen({Key? key}) : super(key: key);

  @override
  _StockTakeScreenState createState() => _StockTakeScreenState();
}

class _StockTakeScreenState extends State<StockTakeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1; // Track the current page

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StockTakeBloc>().add(
        FetchStockTakeEvent(page: _currentPage),
      );
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      _searchController.clear();
      _currentPage = 1; // Reset to first page when toggling search
      if (!_isSearching) {
        context.read<StockTakeBloc>().add(
          FetchStockTakeEvent(page: _currentPage),
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
      context.read<StockTakeBloc>().add(
        FetchStockTakeFilteredEvent(
          textToSearch: _searchController.text,
          page: _currentPage,
        ),
      );
    } else {
      context.read<StockTakeBloc>().add(
        FetchStockTakeEvent(page: _currentPage),
      );
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
                    hintText: "Tìm kiếm kiểm đếm...",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    _currentPage = 1; // Reset to first page on search
                    context.read<StockTakeBloc>().add(
                      FetchStockTakeFilteredEvent(
                        textToSearch: value,
                        page: _currentPage,
                      ),
                    );
                  },
                )
                : const Text(
                  'Kiểm đếm',
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
              child: BlocBuilder<StockTakeBloc, StockTakeState>(
                builder: (context, state) {
                  if (state is StockTakeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is StockTakeLoaded) {
                    final StockTakes = state.stockTakes;
                    final totalPages = state.stockTakes.TotalPages;

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
                              itemCount: StockTakes.Data.length,
                              itemBuilder: (context, index) {
                                return StockTakeCard(
                                  stockTake: StockTakes.Data[index],
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
