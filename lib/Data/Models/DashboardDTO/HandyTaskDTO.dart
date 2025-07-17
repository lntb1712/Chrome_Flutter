class HandyTaskDTO {
  final String orderCode;
  final String orderType;
  final String deadline;
  final String status;
  final List<String> productCodes;

  HandyTaskDTO({
    required this.orderCode,
    required this.orderType,
    required this.deadline,
    required this.status,
    required this.productCodes,
  });

  factory HandyTaskDTO.fromJson(Map<String, dynamic> json) {
    return HandyTaskDTO(
      orderCode: json['OrderCode'],
      orderType: json['OrderType'],
      deadline: json['Deadline'],
      status: json['Status'],
      productCodes: List<String>.from(json['ProductCodes']),
    );
  }
}
