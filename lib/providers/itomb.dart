import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:itombs/library.dart';

class ItombProvider extends ChangeNotifier {
  List<ItombModel> allItombs = [], myItombs = [];
  bool isLoading = false;

  Future<void> load(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    final params = {"": ""};
    final QueryResult result = await UtilProvider().gqRequest(
        UtilProvider.selectedPageIndex == 1
            ? Queries.getMyItombs
            : Queries.getAllItombs,
        params);
    if (result.data != null &&
        (UtilProvider.selectedPageIndex == 1
                ? result.data['getItembs']
                : result.data['getAllItembs']) !=
            null) {
      List<dynamic> list = UtilProvider.selectedPageIndex == 1
          ? result.data['getItembs']
          : result.data['getAllItembs'];
      (UtilProvider.selectedPageIndex == 1 ? myItombs : allItombs).addAll(
          list.map<ItombModel>((item) => ItombModel.fromJson(item)).toList());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> create(BuildContext context, dynamic params,
      {bool isUpdate = false}) async {
    UtilProvider().showProgressing(context);
    final QueryResult result = await UtilProvider().gqRequest(
        isUpdate ? Queries.updateItomb : Queries.createItomb, params);
    Navigator.pop(context);
    if (result.data != null &&
        result.data[isUpdate ? 'updateItomb' : 'addItomb'] != null) {
      final itomb = ItombModel.fromJson(
          result.data[isUpdate ? 'updateItomb' : 'addItomb']);
      if (isUpdate) {
        final index1 = allItombs.indexOf(
            allItombs.where((element) => element.id == itomb.id).first);
        allItombs[index1] = itomb;
        final index2 = myItombs
            .indexOf(myItombs.where((element) => element.id == itomb.id).first);
        myItombs[index2] = itomb;
      } else {
        allItombs.add(itomb);
        myItombs.add(itomb);
      }
      UtilProvider().showToast(
          context,
          isUpdate
              ? 'Success to update an itomb'
              : 'Success to create new itomb');
      notifyListeners();
      return true;
    } else {
      UtilProvider().showToast(context, 'Failed to create new itomb');
      return false;
    }
  }

  Future<void> remove(BuildContext context, String itombID) async {
    dynamic params = {
      "ids": [itombID]
    };
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.removeItombs, params);
    if (result.data != null && result.data['removeItombs'] != null) {
      allItombs = allItombs.where((element) => element.id != itombID).toList();
      myItombs = myItombs.where((element) => element.id != itombID).toList();
      notifyListeners();
    }
  }

  Future<void> leave(BuildContext context, String itombID) async {
    dynamic params = {"id": itombID};
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.leaveItomb, params);
    if (result.data != null && result.data['leaveItomb'] != null) {
      allItombs = allItombs.where((element) => element.id != itombID).toList();
      myItombs = myItombs.where((element) => element.id != itombID).toList();
      notifyListeners();
    }
  }

  void clear() {
    allItombs.clear();
    myItombs.clear();
    UtilProvider.gqClient.cache.reset();
  }
}
