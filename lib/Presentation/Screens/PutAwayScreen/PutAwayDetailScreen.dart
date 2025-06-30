import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/PutAwayDetailBloc/PutAwayDetailBloc.dart';
import '../../../Blocs/PutAwayDetailBloc/PutAwayDetailEvent.dart';
import '../../../Blocs/PutAwayDetailBloc/PutAwayDetailState.dart';
import '../../Widgets/PutAwayWidget/PutAwayDetailCard.dart';

class PutAwayDetailScreen extends StatefulWidget {
  final String putAwayCode;

  const PutAwayDetailScreen({Key? key, required this.putAwayCode})
    : super(key: key);

  @override
  _PutAwayDetailScreenState createState() => _PutAwayDetailScreenState();
}

class _PutAwayDetailScreenState extends State<PutAwayDetailScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PutAwayDetailBloc>().add(
        FetchPutAwayDetail(putAwayCode: widget.putAwayCode),
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
                      '#${widget.putAwayCode}',
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
              child: BlocBuilder<PutAwayDetailBloc, PutAwayDetailState>(
                builder: (context, state) {
                  if (state is PutAwayDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PutAwayDetailLoaded) {
                    final filteredPutAwayDetails =
                        state.putAwayDetailResponseDTO;
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<PutAwayDetailBloc>().add(
                          FetchPutAwayDetail(putAwayCode: widget.putAwayCode),
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: filteredPutAwayDetails.length,
                        itemBuilder: (context, index) {
                          return PutAwayDetailCard(
                            putAwayDetail: filteredPutAwayDetails[index],
                          );
                        },
                      ),
                    );
                  } else if (state is PutAwayDetailError) {
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
                              context.read<PutAwayDetailBloc>().add(
                                FetchPutAwayDetail(
                                  putAwayCode: widget.putAwayCode,
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
