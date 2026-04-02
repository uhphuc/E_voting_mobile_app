class OptionModel {
  final int id;
  final String name;
  final String description;
  final int sum;
  final int roomId;
  final DateTime createdAt;

  OptionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.sum,
    required this.roomId,
    required this.createdAt,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? "",
      sum: json['sum'],
      roomId: json['roomId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "sum": sum,
      "roomId": roomId,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}