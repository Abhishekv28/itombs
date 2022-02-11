import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:itombs/library.dart';

class VideoProvider extends ChangeNotifier {
  List<VideoModel> videos = [];
  VideoModel selectedVideo;
  bool isLoading = false;

  Future<void> load(BuildContext context, dynamic params) async {
    isLoading = true;
    notifyListeners();
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.getVideos, params);
    if (result.data != null && (result.data['getVideos']) != null) {
      List<dynamic> list = result.data['getVideos'];
      videos.addAll(
          list.map<VideoModel>((item) => VideoModel.fromJson(item)).toList());
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> add(BuildContext context, dynamic params,
      {bool isUpdate = false}) async {
    UtilProvider().showProgressing(context);
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.addVideo, params);
    Navigator.pop(context);
    if (result.data != null && result.data['addVideo'] != null) {
      final post = VideoModel.fromJson(result.data['addVideo']);
      videos.add(post);
      UtilProvider().showToast(context, 'Success to add a video');
      notifyListeners();
      return true;
    } else {
      UtilProvider().showToast(context, 'Failed to add a video');
      return false;
    }
  }

  Future<bool> like(BuildContext context, String videoID) async {
    final params = {'tag': 'video', 'tag_id': videoID};
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.toggleLike, params);
    if (result.data != null && result.data['toggleLike'] != null) {
      return true;
    } else {
      return false;
    }
  }

  void updateLikedNum(int num, String postID) {
    final list = videos.where((element) => element.id == postID);
    if (list != null) {
      final index = videos.indexOf(list.toList().first);
      videos[index].numOfLikes = num;
      notifyListeners();
    }
  }

  void clear() {
    videos.clear();
    UtilProvider.gqClient.cache.reset();
    notifyListeners();
  }
}
