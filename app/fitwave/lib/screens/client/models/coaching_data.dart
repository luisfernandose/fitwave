class CoachingData {
  final String idCoaching;
  final String? customer;
  final String startDate;
  final String endDate;
  final double points;
  final double promoPoints;
  final double totalPoints;
  final int totalSessions;
  final int pendingSessions;
  final String idCustomer;
  final String insertDate;
  final String editDate;
  final String? userCreate;
  final String? userEdit;
  final bool active;
  final bool coachingComplete;
  final bool isDelete;

  CoachingData({
    required this.idCoaching,
    this.customer,
    required this.startDate,
    required this.endDate,
    required this.points,
    required this.promoPoints,
    required this.totalPoints,
    required this.totalSessions,
    required this.pendingSessions,
    required this.idCustomer,
    required this.insertDate,
    required this.editDate,
    this.userCreate,
    this.userEdit,
    required this.active,
    required this.coachingComplete,
    required this.isDelete,
  });

  factory CoachingData.fromJson(Map<String, dynamic> json) {
    return CoachingData(
      idCoaching: json['idCoaching'],
      customer: json['customer'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      points: json['points'],
      promoPoints: json['promoPoints'],
      totalPoints: json['totalPoints'],
      totalSessions: json['totalSessions'],
      pendingSessions: json['pendingSessions'],
      idCustomer: json['idCustomer'],
      insertDate: json['insertDate'],
      editDate: json['editDate'],
      userCreate: json['userCreate'],
      userEdit: json['userEdit'],
      active: json['active'],
      coachingComplete: json['coachingComplete'],
      isDelete: json['isDelete'],
    );
  }
}
