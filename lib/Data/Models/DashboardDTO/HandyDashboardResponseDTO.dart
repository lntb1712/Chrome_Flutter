import 'HandyTaskDTO.dart';

class HandyDashboardResponseDTO {
  final List<String> alerts;
  final List<HandyTaskDTO> todoTasks;
  final Map<String, int> summaryToday;

  HandyDashboardResponseDTO({
    required this.alerts,
    required this.todoTasks,
    required this.summaryToday,
  });

  factory HandyDashboardResponseDTO.fromJson(Map<String, dynamic> json) {
    return HandyDashboardResponseDTO(
      alerts: List<String>.from(json['Alerts']),
      todoTasks: List<HandyTaskDTO>.from(
        json['TodoTasks'].map((x) => HandyTaskDTO.fromJson(x)),
      ),
      summaryToday: Map<String, int>.from(json['SummaryToday']),
    );
  }
}
