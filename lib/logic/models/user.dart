class CurrentUser {
  final String uid;
  final String empId;
  final String displayName;
  final String? photoURL;

  final String department;
  final String? role;

  CurrentUser.withAttributes({
    required this.uid,
    required this.empId,
    required this.displayName,
    this.photoURL,
    required this.department,
    this.role,
  });

  factory CurrentUser.fromDB(Map data) {
    return CurrentUser.withAttributes(
      uid: data['uid'],
      empId: data['empId'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      department: data['department'],
      role: data['role'],
    );
  }
}
