import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/PutAwayBloc/PutAwayBloc.dart';
import '../../../Blocs/PutAwayBloc/PutAwayEvent.dart';
import '../../../Blocs/PutAwayBloc/PutAwayState.dart';
import '../../Widgets/PutAwayWidget/PutAwayCard.dart';
import '../../Widgets/SideBarMenu/SideBarMenu.dart';

class PutAwayScreen extends StatefulWidget {
  final String? orderCode; // Thêm orderCode để lọc putaway theo Transfer
  const PutAwayScreen({Key? key, this.orderCode}) : super(key: key);

  @override
  _PutAwayScreenState createState() => _PutAwayScreenState();
}

class _PutAwayScreenState extends State<PutAwayScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    // Ensure the widget is mounted before accessing context.
    // Future.microtask is a good way to do this for BLoC events in initState.
    Future.microtask(() {
      if (mounted) {
        // Check if the widget is still in the tree
        if (widget.orderCode != null) {
          // Nếu có orderCode, load putaway theo Transfer
          context.read<PutAwayBloc>().add(
            FetchPutAwayContainsCodeEvent(orderCode: widget.orderCode!),
          );
        } else {
          // Load danh sách putaway bình thường
          context.read<PutAwayBloc>().add(
            FetchPutAwayEvent(page: _currentPage),
          );
        }
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear(); // Clear search text only when closing search
        // If not searching anymore and no specific orderCode filter, refresh the list
        if (widget.orderCode == null) {
          _currentPage = 1; // Reset to first page
          context.read<PutAwayBloc>().add(
            FetchPutAwayEvent(page: _currentPage),
          );
        }
      } else {
        // When opening search, if there's an orderCode, the search should likely
        // override it or be disabled. For now, we assume search takes precedence.
        // If orderCode is active, and user starts searching, we fetch filtered results.
        // If no orderCode, then also fetch filtered results.
        _currentPage = 1; // Reset to first page for new search
        // Optional: you might want to immediately trigger a search if _searchController.text is not empty
        // or wait for user input in onChanged. Current setup waits for onChanged.
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
    if (!mounted) return; // Don't fetch if the widget is disposed

    if (_isSearching && _searchController.text.isNotEmpty) {
      context.read<PutAwayBloc>().add(
        FetchPutAwayFilteredEvent(
          textToSearch: _searchController.text,
          page: _currentPage,
        ),
      );
    } else if (widget.orderCode != null) {
      // If not searching (or search text is empty) but an orderCode is present,
      // prioritize the orderCode filter.
      // Note: The original logic in initState and _toggleSearch might imply
      // that if orderCode is present, search is a separate mode.
      // This fetchData assumes if you're NOT actively searching via the text field,
      // the orderCode filter (if present) is the primary filter.
      context.read<PutAwayBloc>().add(
        FetchPutAwayContainsCodeEvent(orderCode: widget.orderCode!),
        // Typically, FetchPutAwayContainsCodeEvent might not need a page if it fetches all matching.
        // If it does support pagination, you might need to pass _currentPage here too.
        // For now, assuming it fetches all for the given code.
      );
    } else {
      // Default: Not searching, no orderCode, so fetch paginated list.
      context.read<PutAwayBloc>().add(FetchPutAwayEvent(page: _currentPage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarMenu(),
      appBar: AppBar(
        leading: Builder(
          // Use Builder to ensure correct context for Scaffold.of(context)
          builder: (context) {
            return widget.orderCode == null
                ? IconButton(
                  icon: const Icon(Icons.menu, size: 30, color: Colors.white),
                  tooltip: 'Mở menu',
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                )
                : IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  tooltip: 'trở về',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
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
                    hintText: "Tìm kiếm cất kho...",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    _currentPage = 1; // Reset page on new search term
                    // Only trigger search if text is not empty, or handle empty text to show all
                    if (value.isNotEmpty) {
                      context.read<PutAwayBloc>().add(
                        FetchPutAwayFilteredEvent(
                          textToSearch: value,
                          page: _currentPage,
                        ),
                      );
                    } else {
                      // If search text is cleared, and no orderCode, fetch all
                      if (widget.orderCode == null) {
                        context.read<PutAwayBloc>().add(
                          FetchPutAwayEvent(page: _currentPage),
                        );
                      } else {
                        // If search text is cleared, but there's an orderCode, refetch for that orderCode
                        context.read<PutAwayBloc>().add(
                          FetchPutAwayContainsCodeEvent(
                            orderCode: widget.orderCode!,
                          ),
                        );
                      }
                    }
                  },
                )
                : Text(
                  widget.orderCode != null
                      ? 'Cất hàng cho ${widget.orderCode}'
                      : 'Cất hàng',
                  style: const TextStyle(
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
        // No shadow
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<PutAwayBloc, PutAwayState>(
                builder: (context, state) {
                  if (state is PutAwayLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Define variables for list and total pages to avoid repetition
                  List<dynamic> currentPutAways =
                      []; // Assuming dynamic for now, specify your model type
                  int totalPages = 1;
                  bool hasData = false;

                  if (state is PutAwayLoaded) {
                    // Assuming state.putAwayResponses has an 'items' list and 'TotalPages'
                    // Replace 'items' with the actual name of your list property
                    currentPutAways = state.putAwayResponses.Data;
                    totalPages = state.putAwayResponses.TotalPages;
                    hasData = true;
                  } else if (state is PutAwayContainsCodeLoaded) {
                    // Assuming state.putAwayResponses has an 'items' list and 'TotalPages'
                    // Replace 'items' with the actual name of your list property
                    currentPutAways = state.putAwayResponses;
                    // If filtered by code, often it's a single list without server-side pagination
                    // Or it might still have TotalPages. Adjust as per your API.
                    totalPages = 1;
                    hasData = true;
                  } else if (state is PutAwayError) {
                    // Explicitly handle error state
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.message,
                            // Display error from state
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _currentPage = 1;
                              _fetchData(); // Retry
                            },
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!hasData || currentPutAways.isEmpty) {
                    // Handle empty state after loading, if not already covered by error state
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inbox_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _isSearching
                                ? 'Không tìm thấy kết quả nào.'
                                : 'Không có dữ liệu cất hàng.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          if (widget.orderCode != null && !_isSearching)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Cho mã: ${widget.orderCode}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }

                  // If we have data
                  return Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _currentPage = 1; // Reset to first page on refresh
                            _fetchData();
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.all(10.0),
                            itemCount: currentPutAways.length,
                            itemBuilder: (context, index) {
                              // Make sure currentPutAways[index] is the correct model type
                              // for PutAwayCard.
                              return PutAwayCard(
                                putAway: currentPutAways[index],
                              );
                            },
                          ),
                        ),
                      ),
                      // Only show pagination if not filtering by a specific orderCode
                      // AND if there's more than one page.
                      if (widget.orderCode == null && totalPages > 1)
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
                                          ? Colors
                                              .blue // Or Theme.of(context).primaryColor
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
                                'Trang $_currentPage / $totalPages',
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
                                          ? Colors
                                              .blue // Or Theme.of(context).primaryColor
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
