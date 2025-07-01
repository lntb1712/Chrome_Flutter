import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/PickListBloc/PickListBloc.dart';
import '../../../Blocs/PickListBloc/PickListEvent.dart';
import '../../../Blocs/PickListBloc/PickListState.dart';
import '../../Widgets/PickListWidget/PickListCard.dart';
import '../../Widgets/SideBarMenu/SideBarMenu.dart';

class PickListScreen extends StatefulWidget {
  const PickListScreen({Key? key}) : super(key: key);

  @override
  _PickListScreenState createState() => _PickListScreenState();
}

class _PickListScreenState extends State<PickListScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PickListBloc>().add(FetchPickListEvent());
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      _searchController.clear();
      if (!_isSearching) {
        context.read<PickListBloc>().add(FetchPickListEvent());
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
                          hintText: "Tìm kiếm pick list...",
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
                          context.read<PickListBloc>().add(
                            FetchPickListFilteredEvent(textToSearch: value),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<PickListBloc, PickListState>(
                builder: (context, state) {
                  if (state is PickListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PickListLoaded) {
                    final filteredPickLists = state.pickLists;

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<PickListBloc>().add(FetchPickListEvent());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: filteredPickLists.length,
                        itemBuilder: (context, index) {
                          return PickListCard(
                            pickList: filteredPickLists[index],
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
