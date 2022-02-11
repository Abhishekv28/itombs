import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:itombs/library.dart';

class MessageProvider extends ChangeNotifier {
  List<MessageModel> messages = [];
  bool isLoading = false;

  Future<void> load(BuildContext context, dynamic params) async {
    isLoading = true;
    notifyListeners();

    final QueryResult result =
        await UtilProvider().gqRequest(Queries.getMessages, params);
    if (result.data != null && (result.data['messages']) != null) {
      List<dynamic> list = result.data['messages'];
      messages.addAll(list
          .map<MessageModel>((item) => MessageModel.fromJson(item))
          .toList());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> add(String message, String chatID) async {
    final param = {
      'input': {'thread': chatID, 'data': message, 'type': 'TEXT'}
    };
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.addMessage, param);
    if (result.data != null && (result.data['addMessage']) != null) {
      messages.insert(0, MessageModel.fromJson(result.data['addMessage']));
    }
    notifyListeners();
  }

  void updateListWithMessage(MessageModel message) {
    final list = messages.where((element) => element.id == message.id).toList();
    if (list.isNotEmpty) {
      final index = messages.indexOf(list.first);
      messages[index] = message;
    } else {
      messages.insert(0, message);
    }
    notifyListeners();
  }

  void clear() {
    messages.clear();
    UtilProvider.gqClient.cache.reset();
    notifyListeners();
  }
}
