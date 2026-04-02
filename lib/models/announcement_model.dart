class AnnouncementModel {
  final int id;
  final String title;
  final String message;
  final String type;
  final int senderId;
  final DateTime createdAt;
  final bool isRead;
  final int receiverId;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.senderId,
    required this.createdAt,
    required this.isRead,
    required this.receiverId
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      senderId: json['senderId'],
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'],
      receiverId: json['receiverId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'senderId': senderId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}