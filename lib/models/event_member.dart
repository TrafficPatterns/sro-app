class EventMemberModel {
  String? firstName;
  String? lastName;
  String? userID;
  int? parentCount;
  int? studentCount;
  DateTime? joinedDate;
  String? date;
  int? total;
  EventMemberModel(
      {this.firstName,
      this.joinedDate,
      this.lastName,
      this.parentCount,
      this.studentCount,
      this.total,
      this.userID});

  String getFullName() {
    return '$firstName $lastName';
  }

  static EventMemberModel getEventMemberFromMap(dynamic map) {
    return EventMemberModel(
      firstName: map['firstName'],
      lastName: map['lastName'],
      parentCount: int.tryParse(map['parentsCount']) ?? 0,
      studentCount: int.tryParse(map['studentsCount']) ?? 0,
      userID: map['userID'],
      joinedDate: DateTime.tryParse(map['joinDate']),
      total: (int.tryParse(map['parentsCount']) ?? 0) +
          (int.tryParse(map['studentsCount']) ?? 0),
    );
  }
}
