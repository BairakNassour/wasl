class NotesModel {
  final int id;
  final String title;
  final String descriptions;
  final String? replay;
  final int senderId;
  final int reciverId;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AttachModel? attach;
  final UserModel sender;
  final UserModel reciver;

  NotesModel({
    required this.id,
    required this.title,
    required this.descriptions,
    this.replay,
    required this.senderId,
    required this.reciverId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.attach,
    required this.sender,
    required this.reciver,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json['id'],
      title: json['title'],
      descriptions: json['descriptions'],
      replay: json['replay'],
      senderId: json['sender_id'],
      reciverId: json['reciver_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      attach: json['attach'] != null ? AttachModel.fromJson(json['attach']) : null,
      sender: UserModel.fromJson(json['sender']),
      reciver: UserModel.fromJson(json['reciver']),
    );
  }
}

class AttachModel {
  final int id;
  final String name;
  final String path;
  final String? replayFile;
  final String? replayPath;
  final int senderId;
  final int messageId;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttachModel({
    required this.id,
    required this.name,
    required this.path,
    this.replayFile,
    this.replayPath,
    required this.senderId,
    required this.messageId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttachModel.fromJson(Map<String, dynamic> json) {
    return AttachModel(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      replayFile: json['replay_file'],
      replayPath: json['replay_path'],
      senderId: json['sender_id'],
      messageId: json['message_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
class UserModel {
  final int id;
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final String phone;
  final int type;
  final String status;
  final String? fcmToken;
  final String? accessToken;
  final String? image;
  final String? link;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.phone,
    required this.type,
    required this.status,
    this.fcmToken,
    this.accessToken,
    this.image,
    this.link,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      type: json['type'],
      status: json['status'],
      fcmToken: json['fcm_token'],
      accessToken: json['access_token'],
      image: json['image'],
      link: json['link'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
