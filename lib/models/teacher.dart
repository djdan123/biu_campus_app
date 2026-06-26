class Teacher {
  String id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String department;
  List<String> courseIds; // cours enseignés

  Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.department,
    this.courseIds = const [],
  });

  String get fullName => '$firstName $lastName';
}