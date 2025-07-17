import 'package:chrome_flutter/Data/Models/DashboardDTO/HandyDashboardResponseDTO.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final HandyDashboardResponseDTO handyDashboardResponseDTO;

  DashboardLoaded({required this.handyDashboardResponseDTO});
}

class DashboardError extends DashboardState {
  final String error;

  DashboardError({required this.error});
}
