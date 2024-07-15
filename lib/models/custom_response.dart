class CustomResponse {
  final bool error;
  final dynamic data;
  final String message;
  final List<String>? validationErrors;
  final Map<String, dynamic> paginationInfo;

  CustomResponse(
      {required this.error,
      required this.data,
      required this.message,
      required this.validationErrors,
      required this.paginationInfo});

  factory CustomResponse.fromJson(Map<String, dynamic> json) {
    return CustomResponse(
      error: json['error'],
      data: json['data'],
      message: json['message'],
      validationErrors: json['validationErrors'] != null
          ? List<String>.from(json['validationErrors'])
          : [],
      paginationInfo: json["paginationInfo"] != null ? json["paginationInfo"]  : {} ,
    );
  }
}
