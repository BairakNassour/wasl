class NotificationModel {
  final int id;
  final String text;
  final String createdAt;
  final String? senderName;
  final String? title;
  final String? description;
  final String? senderImage;

  NotificationModel({
    required this.id,
    required this.text,
    required this.createdAt,
    this.senderName,
    this.title,
    this.description,
    this.senderImage,
  });

  // إنشاء مصنع لتحويل البيانات من JSON إلى كائن NotificationModel
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      text: json['text'],
      createdAt: json['created_at'],
      senderName: "${json['sender']['firstname']} ${json['sender']['lastname']}",
      title: json['message']['title'],
      description: json['message']['descriptions'],
      senderImage: json['sender']['link'],
    );
  }
}
