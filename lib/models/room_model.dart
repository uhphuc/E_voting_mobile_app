class RoomModel {
  final int id;
  final String roomCode;
  final String name;
  final String description;
  final int managerId;
  final bool isActive;
  final String createdAt;
  final String? closesAt;

  RoomModel({
    required this.id,
    required this.roomCode,
    required this.name,
    required this.description,
    required this.managerId,
    required this.isActive,
    required this.createdAt,
    this.closesAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      roomCode: json['roomCode'],
      name: json['name'],
      description: json['description'],
      managerId: json['managerId'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      closesAt: json['closesAt'],
    );
  }
}