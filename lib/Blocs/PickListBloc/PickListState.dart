import 'package:chrome_flutter/Data/Models/PagedResponse/PagedResponse.dart';
import 'package:chrome_flutter/Data/Models/PickListDTO/PickAndDetailResponseDTO.dart';
import 'package:chrome_flutter/Data/Models/PickListDTO/PickListResponseDTO.dart';

abstract class PickListState {}

class PickListInitial extends PickListState {}

class PickListLoading extends PickListState {}

class PickListLoaded extends PickListState {
  final PagedResponse<PickListResponseDTO> pickLists;

  PickListLoaded({required this.pickLists});
}

class PickLoaded extends PickListState {
  final PickAndDetailResponseDTO pickLists;

  PickLoaded({required this.pickLists});
}

class PickListError extends PickListState {
  final String message;

  PickListError({required this.message});
}
