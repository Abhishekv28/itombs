import 'package:itombs/models/library.dart';

class ChatModel {
  final String id;
  final int unreadNum;
  final List<UserModel> users;
  final List<MessageModel> messages;

  ChatModel(
      {this.id,
      this.unreadNum,
      this.users,
      this.messages});

  factory ChatModel.fromJson(Map<String, dynamic> data) => ChatModel(
      id: data['id'],
      messages: data['messages'].isNotEmpty ? data['messages']
          .map<MessageModel>((item) => MessageModel.fromJson(item))
          .toList() : [],
      unreadNum: data['unreadMessages'] ?? 'unknown',
      users: data['participants']
          .map<UserModel>((item) => UserModel.fromJson(item))
          .toList());
}
