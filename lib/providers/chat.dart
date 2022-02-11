import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:itombs/library.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatModel> chats = [];
  static ChatModel selectedChat;
  bool isLoading = false;

  Future<void> load(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final QueryResult result =
        await UtilProvider().gqRequest(Queries.getChats, {
      'limit': 2,
      'sort': {'feature': 'CREATED_AT', 'type': 'DESC'}
    });
    if (result.data != null && (result.data['myMessageThreads']) != null) {
      List<dynamic> list = result.data['myMessageThreads'];
      chats.addAll(
          list.map<ChatModel>((item) => ChatModel.fromJson(item)).toList());
    }
    isLoading = false;
    notifyListeners();
  }

  Future<ChatModel> add(String userID) async {
    final param = {
      'input': {
        'receivers': [userID]
      }
    };
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.addChat, param);
    ChatModel chat;
    if (result.data != null && (result.data['addMessageThread']) != null) {
      chat = ChatModel.fromJson(result.data['addMessageThread']);
      chats.add(chat);
      return chat;
    }
    return chat;
  }

  void updateList(ChatModel chat) {
    final list = chats.where((element) => element.id == chat.id).toList();
    if (list.isEmpty) {
      chats.add(chat);
    } else {
      chats[chats.indexOf(list.first)] = chat;
    }
    notifyListeners();
  }

  void updateListWithMessage(MessageModel message) {
    final list =
        chats.where((element) => element.id == message.chatID).toList();
    if (list.isNotEmpty) {
      final index = chats.indexOf(list.first);
      chats[index].messages.insert(0, message);
      if (chats[index].messages.length > 5) chats[index].messages.removeLast();
      notifyListeners();
    }
  }

  void clear() {
    chats.clear();
    UtilProvider.gqClient.cache.reset();
    notifyListeners();
  }
}
