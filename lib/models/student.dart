class Student {
  String id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String department;
  String promotion; // ex: "L1", "L2", "M1"
  List<String> courseIds; // IDs des cours suivis
  DateTime enrollmentDate;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.department,
    required this.promotion,
    this.courseIds = const [],
    required this.enrollmentDate,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toMap() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'department': department,
    'promotion': promotion,
    'courseIds': courseIds,
    'enrollmentDate': enrollmentDate.toIso8601String(),
  };

  factory Student.fromMap(Map<String, dynamic> map) => Student(
    id: map['id'],
    firstName: map['firstName'],
    lastName: map['lastName'],
    email: map['email'],
    phone: map['phone'],
    department: map['department'],
    promotion: map['promotion'],
    courseIds: List<String>.from(map['courseIds'] ?? []),
    enrollmentDate: DateTime.parse(map['enrollmentDate']),
  );
}