import 'package:chrome_flutter/Presentation/Screens/PickListScreen/PickAndDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/PickListBloc/PickListBloc.dart';
import '../../../Blocs/PickListBloc/PickListEvent.dart';
import '../../../Blocs/PickListBloc/PickListState.dart';
import '../../../Blocs/PutAwayBloc/PutAwayBloc.dart';
import '../../../Blocs/PutAwayBloc/PutAwayEvent.dart';
import '../../../Blocs/PutAwayBloc/PutAwayState.dart';
import '../../../Data/Models/MovementDTO/MovementResponseDTO.dart';
import '../../../Data/Models/MovementDetailDTO/MovementDetailResponseDTO.dart';
import '../../Screens/PutAwayScreen/PutAwayAndDetailScreen.dart';

class MovementDetailCard extends StatefulWidget {
  final MovementDetailResponseDTO movementDetail;
  final MovementResponseDTO movementResponseDTO;

  const MovementDetailCard({
    super.key,
    required this.movementDetail,
    required this.movementResponseDTO,
  });

  @override
  _MovementDetailCardState createState() => _MovementDetailCardState();
}

class _MovementDetailCardState extends State<MovementDetailCard> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    context.read<PickListBloc>().add(
      FetchPickAndDetailEvent(orderCode: widget.movementDetail.MovementCode),
    );
    context.read<PutAwayBloc>().add(
      FetchPutAwayAndDetailEvent(orderCode: widget.movementDetail.MovementCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: _isExpanded ? Colors.lightBlueAccent : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${widget.movementDetail.ProductName}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                BlocBuilder<PickListBloc, PickListState>(
                  builder: (context, pickListState) {
                    if (pickListState is PickLoaded) {
                      if (pickListState.pickLists.StatusId != 3) {
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PickAndDetailScreen(
                                      orderCode:
                                          widget.movementDetail.MovementCode,
                                    ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.black38,
                            elevation: 5,
                          ),
                          child: const Text(
                            'Lấy hàng',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                    }
                    if (pickListState is PickLoaded &&
                        pickListState.pickLists.StatusId == 3) {
                      return BlocBuilder<PutAwayBloc, PutAwayState>(
                        builder: (context, putAwayState) {
                          bool showPutAwayButton = true;
                          if (putAwayState is PutAwayAndDetailLoaded &&
                              putAwayState.putAwayResponses.StatusId == 3) {
                            showPutAwayButton = false;
                          }
                          return showPutAwayButton
                              ? ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => PutAwayAndDetailScreen(
                                            orderCode:
                                                widget
                                                    .movementDetail
                                                    .MovementCode,
                                          ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.black38,
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'Cất hàng',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : const SizedBox.shrink();
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// Always-visible Info
            _buildInfoRow(
              Icons.code,
              "Mã sản phẩm",
              widget.movementDetail.ProductCode,
            ),
            _buildInfoRow(
              Icons.format_list_numbered,
              "Số lượng",
              "${widget.movementDetail.Demand ?? 0}",
            ),
            _buildInfoRow(
              Icons.move_down,
              "Mã di chuyển",
              widget.movementDetail.MovementCode,
            ),
            const SizedBox(height: 2),

            /// Expanded Info
            if (_isExpanded) ...[
              const Divider(thickness: 1, color: Colors.grey),
              _buildInfoRow(
                Icons.person,
                "Người phụ trách",
                widget.movementResponseDTO.FullNameResponsible,
              ),
              _buildInfoRow(
                Icons.warehouse,
                "Kho",
                widget.movementResponseDTO.WarehouseName,
              ),
              _buildInfoRow(
                Icons.location_on,
                "Vị trí nguồn",
                widget.movementResponseDTO.FromLocationName,
              ),
              _buildInfoRow(
                Icons.location_on,
                "Vị trí đích",
                widget.movementResponseDTO.ToLocationName,
              ),
              _buildInfoRow(
                Icons.edit_calendar_rounded,
                "Loại lệnh",
                widget.movementResponseDTO.OrderTypeName,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Colors.black54),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
