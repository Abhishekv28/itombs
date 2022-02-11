import 'package:itombs/library.dart';

class PostModel {
  final String id;
  final UserModel user;
  final List<String> photos;
  final String content;
  int numOfLikes;
  final bool isLiked;

  PostModel(
      {this.id,
      this.user,
      this.photos,
      this.content,
      this.numOfLikes,
      this.isLiked});

  factory PostModel.fromJson(Map<String, dynamic> data) => PostModel(
      id: data['id'],
      user: UserModel.fromJson(data['user']),
      content: data['content'],
      numOfLikes: data['like_count'] ?? 0,
      isLiked: data['is_liked'] ?? false,
      photos: (data['photo'] != null) && (data['photo'].length > 0)
          ? data['photo'].map<String>((item) => item['url'].toString()).toList()
          : []);
}
