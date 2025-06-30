class APIResult<T> {
  final bool Success;
  final String Message;
  final T? Data;

  APIResult({required this.Success, required this.Message, this.Data});

  factory APIResult.fromJson(
    Map<String, dynamic> json, [
    T Function(dynamic)? fromJsonT,
  ]) {
    return APIResult<T>(
      Success: json['Success'] as bool,
      Message: json['Message'] as String,
      Data:
          json['Data'] != null
              ? (fromJsonT != null
                  ? fromJsonT(json['Data'])
                  : json['Data'] as T)
              : null,
    );
  }

  Map<String, dynamic> toJson([Object? Function(T)? toJsonT]) {
    return {
      'Success': Success,
      'Message': Message,
      'Data':
          Data != null ? (toJsonT != null ? toJsonT(Data as T) : Data) : null,
    };
  }
}
