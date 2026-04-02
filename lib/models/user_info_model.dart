class UserInfoModel {
  final int id;
  final String email;
  final String name;
  final String phone;
  final String gender;
  final DateTime birthDate;
  final String address;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserInfoModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.gender,
    required this.birthDate,
    required this.address,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : DateTime.now(),
      address: json['address'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'gender': gender,
      'birthDate': birthDate.toIso8601String(),
      'address': address,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}