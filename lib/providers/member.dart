import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:itombs/library.dart';

class MemberProvider extends ChangeNotifier {
  ItombModel itomb;
  List<UserModel> addedUsers = [];
  List<UserModel> allUsers = [];
  bool isLoading = false;

  Future<void> load(BuildContext context, {String itombID}) async {
    isLoading = true;
    notifyListeners();
    dynamic params = {"": ''};
    if (itombID != null) params['id'] = itombID;
    final QueryResult result = await UtilProvider().gqRequest(
        itombID != null ? Queries.getUsersByItomb : Queries.getAllUsers,
        params);
    if (result.data != null &&
        (result.data[itombID == null ? 'getAllUsers' : 'getUsersByItomb']) !=
            null) {
      List<dynamic> list =
          result.data[itombID == null ? 'getAllUsers' : 'getUsersByItomb'];
      if (itombID != null) {
        addedUsers.addAll(list
            .map<UserModel>((item) => UserModel.fromJson(item['user']))
            .toList());
      } else {
        allUsers.addAll(
            list.map<UserModel>((item) => UserModel.fromJson(item)).toList());
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> add(BuildContext context, String itombID, UserModel user) async {
    dynamic params = {
      "users": [user.id],
      "itombID": itombID
    };
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.addUsersToItomb, params);
    if (result.data != null && result.data['addUsersToItomb'] != null) {
      addedUsers.add(user);
      notifyListeners();
    }
  }

  Future<void> remove(
      BuildContext context, String itombID, UserModel user) async {
    dynamic params = {
      "users": [user.id],
      "itomb": [itombID]
    };
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.removeUsersOfItomb, params);
    if (result.data != null && result.data['removeUsersOfItomb'] != null) {
      addedUsers.remove(user);
      notifyListeners();
    }
  }

  void clear() {
    addedUsers.clear();
    allUsers.clear();
    UtilProvider.gqClient.cache.reset();
  }
}
