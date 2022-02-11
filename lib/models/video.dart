class VideoModel {
  final String id;
  final String title;
  final String description;
  final String url;
  final String thumbnail;
  final bool isPublic;
  final String userId;
  int numOfLikes;
  final bool isLiked;

  VideoModel(
      {this.id,
      this.title,
      this.description,
      this.url,
      this.thumbnail,
      this.isPublic,
      this.userId,
      this.numOfLikes,
      this.isLiked});

  factory VideoModel.fromJson(Map<String, dynamic> data) => VideoModel(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      url: data['video']['url'],
      thumbnail: data['thumbnail']['url'],
      isPublic: data['isPublic'],
      numOfLikes: data['like_count'] ?? 0,
      isLiked: data['is_liked'] ?? false,
      userId: data['user']);
}
