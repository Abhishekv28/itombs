import 'package:itombs/library.dart';

class MessageModel {
  final String id;
  final String chatID;
  final UserModel user;
  final String message;
  final String time;

  MessageModel({this.id, this.chatID, this.user, this.message, this.time});

  factory MessageModel.fromJson(Map<String, dynamic> data) => MessageModel(
      id: data['id'],
      chatID: data['thread']['id'],
      user: UserModel.fromJson(data['author']),
      message: data['data'],
      time: data['createdAt']);
}
