import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:itombs/library.dart';

class PostProvider extends ChangeNotifier {
  List<PostModel> posts = [];
  bool isLoading = false;

  Future<void> load(BuildContext context, dynamic params) async {
    isLoading = true;
    notifyListeners();
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.getPostsByItomb, params);
    if (result.data != null && (result.data['getPostsByItomb']) != null) {
      List<dynamic> list = result.data['getPostsByItomb'];
      posts.addAll(
          list.map<PostModel>((item) => PostModel.fromJson(item)).toList());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> add(BuildContext context, dynamic params,
      {bool isUpdate = false}) async {
    UtilProvider().showProgressing(context);
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.addPost, params);
    Navigator.pop(context);
    if (result.data != null && result.data['addPost'] != null) {
      final post = PostModel.fromJson(result.data['addPost']);
      posts.add(post);
      UtilProvider().showToast(context, 'Success to add a post');
      notifyListeners();
      return true;
    } else {
      UtilProvider().showToast(context, 'Failed to add a post');
      return false;
    }
  }

  Future<bool> like(BuildContext context, String postID) async {
    final params = {'tag': 'post', 'tag_id': postID};
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.toggleLike, params);
    if (result.data != null && result.data['toggleLike'] != null) {
      print('------- liked --------');
      return true;
    } else {
      return false;
    }
  }

  void updateLikedNum(int num, String postID) {
    final list = posts.where((element) => element.id == postID).toList();
    if (list.isNotEmpty) {
      final index = posts.indexOf(list.first);
      posts[index].numOfLikes = num;
      notifyListeners();
    }
  }

  void clear() {
    posts.clear();
    UtilProvider.gqClient.cache.reset();
    notifyListeners();
  }
}
