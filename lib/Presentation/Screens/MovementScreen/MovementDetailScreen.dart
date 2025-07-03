import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/MovementDetailBloc/MovementDetailBloc.dart';
import '../../../Blocs/MovementDetailBloc/MovementDetailEvent.dart';
import '../../../Blocs/MovementDetailBloc/MovementDetailState.dart';
import '../../../Data/Models/MovementDTO/MovementResponseDTO.dart';
import '../../Widgets/MovementWidget/MovementDetailCard.dart';

class MovementDetailScreen extends StatefulWidget {
  final String movementCode;
  final MovementResponseDTO movement;

  const MovementDetailScreen({
    Key? key,
    required this.movementCode,
    required this.movement,
  }) : super(key: key);

  @override
  _MovementDetailScreenState createState() => _MovementDetailScreenState();
}

class _MovementDetailScreenState extends State<MovementDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovementDetailBloc>().add(
        FetchMovementDetailEvent(movementCode: widget.movementCode),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
          tooltip: 'Quay lại',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '#${widget.movementCode}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<MovementDetailBloc, MovementDetailState>(
                builder: (context, state) {
                  if (state is MovementDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MovementDetailLoaded) {
                    final movementDetails = state.movements;
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<MovementDetailBloc>().add(
                          FetchMovementDetailEvent(
                            movementCode: widget.movementCode,
                          ),
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: movementDetails.length,
                        itemBuilder: (context, index) {
                          return MovementDetailCard(
                            movementDetail: movementDetails[index],
                            movementResponseDTO: widget.movement,
                          );
                        },
                      ),
                    );
                  } else if (state is MovementDetailError) {
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
                              context.read<MovementDetailBloc>().add(
                                FetchMovementDetailEvent(
                                  movementCode: widget.movementCode,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
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
