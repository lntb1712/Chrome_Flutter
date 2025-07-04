import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/ManufacturingOrderBloc/ManufacturingOrderBloc.dart';
import '../../../Blocs/ManufacturingOrderBloc/ManufacturingOrderEvent.dart';
import '../../../Blocs/ManufacturingOrderBloc/ManufacturingOrderState.dart';
import '../../Widgets/ManufacturingOrderWidget/ManufacturingOrderCard.dart';
import '../../Widgets/SideBarMenu/SideBarMenu.dart';

class ManufacturingOrderScreen extends StatefulWidget {
  const ManufacturingOrderScreen({Key? key}) : super(key: key);

  @override
  _ManufacturingOrderScreenState createState() =>
      _ManufacturingOrderScreenState();
}

class _ManufacturingOrderScreenState extends State<ManufacturingOrderScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1; // Track the current page

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ManufacturingOrderBloc>().add(
        FetchManufacturingOrderEvent(page: _currentPage),
      );
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      _searchController.clear();
      _currentPage = 1; // Reset to first page when toggling search
      if (!_isSearching) {
        context.read<ManufacturingOrderBloc>().add(
          FetchManufacturingOrderEvent(page: _currentPage),
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
      context.read<ManufacturingOrderBloc>().add(
        FetchManufacturingOrderFilteredEvent(
          textToSearch: _searchController.text,
          page: _currentPage,
        ),
      );
    } else {
      context.read<ManufacturingOrderBloc>().add(
        FetchManufacturingOrderEvent(page: _currentPage),
      );
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
                    hintText: "Tìm kiếm lệnh sản xuất...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    _currentPage = 1; // Reset to first page on search
                    context.read<ManufacturingOrderBloc>().add(
                      FetchManufacturingOrderFilteredEvent(
                        textToSearch: value,
                        page: _currentPage,
                      ),
                    );
                  },
                )
                : const Text(
                  'Lệnh sản xuất',
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
              child: BlocBuilder<
                ManufacturingOrderBloc,
                ManufacturingOrderState
              >(
                builder: (context, state) {
                  if (state is ManufacturingOrderLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ManufacturingOrderLoaded) {
                    final manufacturingOrders = state.ManufacturingOrders;
                    final totalPages = state.ManufacturingOrders.TotalPages;

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
                              itemCount: manufacturingOrders.Data.length,
                              itemBuilder: (context, index) {
                                return ManufacturingOrderCard(
                                  manufacturingOrder:
                                      manufacturingOrders.Data[index],
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
