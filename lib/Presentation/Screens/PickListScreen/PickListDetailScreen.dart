import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/PickListDetailBloc/PickListDetailBloc.dart';
import '../../../Blocs/PickListDetailBloc/PickListDetailEvent.dart';
import '../../../Blocs/PickListDetailBloc/PickListDetailState.dart';
import '../../Widgets/PickListWidget/PickListDetailCard.dart';

class PickListDetailScreen extends StatefulWidget {
  final String pickNo;

  const PickListDetailScreen({Key? key, required this.pickNo})
    : super(key: key);

  @override
  _PickListDetailScreenState createState() => _PickListDetailScreenState();
}

class _PickListDetailScreenState extends State<PickListDetailScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PickListDetailBloc>().add(
        FetchPickListDetailEvent(pickNo: widget.pickNo),
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
            // Header with pickNo and back button
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
                      '#${widget.pickNo}',
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

            // List of pick list details
            Expanded(
              child: BlocBuilder<PickListDetailBloc, PickListDetailState>(
                builder: (context, state) {
                  if (state is PickListDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PickListDetailLoaded) {
                    final pickListDetails = state.pickListDetails;
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<PickListDetailBloc>().add(
                          FetchPickListDetailEvent(pickNo: widget.pickNo),
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: pickListDetails.length,
                        itemBuilder: (context, index) {
                          return PickListDetailCard(
                            pickListDetail: pickListDetails[index],
                          );
                        },
                      ),
                    );
                  } else if (state is PickListDetailError) {
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
                              context.read<PickListDetailBloc>().add(
                                FetchPickListDetailEvent(pickNo: widget.pickNo),
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
