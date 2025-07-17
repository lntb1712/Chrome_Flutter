import 'package:chrome_flutter/Data/Models/DashboardDTO/HandyDashboardRequestDTO.dart';

abstract class DashboardEvent {}

class FetchDashboardHandyAsync extends DashboardEvent {
  final HandyDashboardRequestDTO handyDashboardRequestDTO;

  FetchDashboardHandyAsync({required this.handyDashboardRequestDTO});
}
