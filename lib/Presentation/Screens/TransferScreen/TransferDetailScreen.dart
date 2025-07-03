import 'package:chrome_flutter/Data/Models/TransferDTO/TransferResponseDTO.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/TransferDetailBloc/TransferDetailBloc.dart';
import '../../../Blocs/TransferDetailBloc/TransferDetailEvent.dart';
import '../../../Blocs/TransferDetailBloc/TransferDetailState.dart';
import '../../Widgets/TransferWidget/TransferDetailCard.dart';

class TransferDetailScreen extends StatefulWidget {
  final String transferCode;
  final TransferResponseDTO transfer;

  const TransferDetailScreen({
    Key? key,
    required this.transferCode,
    required this.transfer,
  }) : super(key: key);

  @override
  _TransferDetailScreenState createState() => _TransferDetailScreenState();
}

class _TransferDetailScreenState extends State<TransferDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TransferDetailBloc>().add(
        FetchTransferDetailEvent(transferCode: widget.transferCode),
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
            // Header with transferCode and back button
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
                      '#${widget.transferCode}',
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

            // List of transfer details
            Expanded(
              child: BlocBuilder<TransferDetailBloc, TransferDetailState>(
                builder: (context, state) {
                  if (state is TransferDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TransferDetailLoaded) {
                    final transferDetails = state.transfers;
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<TransferDetailBloc>().add(
                          FetchTransferDetailEvent(
                            transferCode: widget.transferCode,
                          ),
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: transferDetails.length,
                        itemBuilder: (context, index) {
                          return TransferDetailCard(
                            transferDetail: transferDetails[index],
                            transferResponseDTO: widget.transfer,
                          );
                        },
                      ),
                    );
                  } else if (state is TransferDetailError) {
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
                              context.read<TransferDetailBloc>().add(
                                FetchTransferDetailEvent(
                                  transferCode: widget.transferCode,
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
}
