class CoachingRequest {
  String? idCoachingRequest;
  dynamic customer;
  double? pointsRequested;
  double? pointsApproved;
  String? status;
  String? comment;
  bool? convertedToCoaching;
  int? requestNumber;
  DateTime? startDate;
  DateTime? endDate;
  int? promoPoints;
  dynamic inserdateString;
  dynamic requestStatus;
  DateTime? insertDate;
  DateTime? editDate;
  dynamic userCreate;
  dynamic userEdit;
  bool? active;
  bool? isDelete;

  CoachingRequest({
    this.idCoachingRequest,
    this.customer,
    this.pointsRequested,
    this.pointsApproved,
    this.status,
    this.comment,
    this.convertedToCoaching,
    this.requestNumber,
    this.startDate,
    this.endDate,
    this.promoPoints,
    this.inserdateString,
    this.requestStatus,
    this.insertDate,
    this.editDate,
    this.userCreate,
    this.userEdit,
    this.active,
    this.isDelete,
  });

  factory CoachingRequest.fromJson(Map<String, dynamic> json) {
    return CoachingRequest(
      idCoachingRequest: json['idCoachingRequest'],
      customer: json['customer'],
      pointsRequested: json['pointsRequested'] ?? 0.0,
      pointsApproved: json['pointsApproved'] ?? 0.0,
      status: json['status'] ?? "",
      comment: json['comment'] ?? "",
      convertedToCoaching: json['convertedToCoaching'] ?? false,
      requestNumber: json['requestNumber'] ?? 0,
      startDate: DateTime.parse(json['startDate'] ?? "0001-01-01T00:00:00"),
      endDate: DateTime.parse(json['endDate'] ?? "0001-01-01T00:00:00"),
      promoPoints: json['promoPoints'] ?? 0,
      inserdateString: json['inserdateString'],
      requestStatus: json['requestStatus'],
      insertDate: DateTime.parse(json['insertDate']),
      editDate: DateTime.parse(json['editDate']),
      userCreate: json['userCreate'],
      userEdit: json['userEdit'],
      active: json['active'] ?? false,
      isDelete: json['isDelete'] ?? false,
    );
  }
}
