class SessionData {
  final String idSession;
  final String? coaching;
  final String sessionDate;
  final double sessionPoints;
  final String? sessionDateComplete;
  final int sessionNumber;
  final String idCoach;
  final String? asessor;
  final String status;
  final double sessionPointsApplied;
  final double sessionPendingPoints;
  final String insertDate;
  final String editDate;
  final String? userCreate;
  final String? userEdit;
  final bool active;
  final bool isDelete;

  SessionData({
    required this.idSession,
    this.coaching,
    required this.sessionDate,
    required this.sessionPoints,
    this.sessionDateComplete,
    required this.sessionNumber,
    required this.idCoach,
    this.asessor,
    required this.status,
    required this.sessionPointsApplied,
    required this.sessionPendingPoints,
    required this.insertDate,
    required this.editDate,
    this.userCreate,
    this.userEdit,
    required this.active,
    required this.isDelete,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      idSession: json['idSession'],
      coaching: json['coaching'],
      sessionDate: json['sessionDate'],
      sessionPoints: (json['sessionPoints'] as num).toDouble(),
      sessionDateComplete: json['sessionDateComplete'],
      sessionNumber: json['sessionNumber'],
      idCoach: json['idCoach'],
      asessor: json['asessor'],
      status: json['status'],
      sessionPointsApplied: (json['sessionPointsApplied'] as num).toDouble(),
      sessionPendingPoints: (json['sessionPendingPoints'] as num).toDouble(),
      insertDate: json['insertDate'],
      editDate: json['editDate'],
      userCreate: json['userCreate'],
      userEdit: json['userEdit'],
      active: json['active'],
      isDelete: json['isDelete'],
    );
  }
}
