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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StockOutBloc>().add(FetchStockOutEvent());
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      _searchController.clear();
      if (!_isSearching) {
        context.read<StockOutBloc>().add(FetchStockOutEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarMenu(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, size: 30, color: Colors.black),
                    tooltip: 'Open menu',
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm xuất kho...",
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon:
                              _isSearching
                                  ? IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                    onPressed: _toggleSearch,
                                  )
                                  : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                        ),
                        onTap: () {
                          if (!_isSearching) {
                            setState(() {
                              _isSearching = true;
                            });
                          }
                        },
                        onChanged: (value) {
                          context.read<StockOutBloc>().add(
                            FetchStockOutFilteredEvent(textToSearch: value),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<StockOutBloc, StockOutState>(
                builder: (context, state) {
                  if (state is StockOutLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is StockOutLoaded) {
                    final filteredStockOuts = state.stockOuts;

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<StockOutBloc>().add(FetchStockOutEvent());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: filteredStockOuts.length,
                        itemBuilder: (context, index) {
                          return StockOutCard(
                            stockOut: filteredStockOuts[index],
                          );
                        },
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
