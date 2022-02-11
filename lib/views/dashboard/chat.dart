import 'package:itombs/library.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key});

  @override
  ChatPageState createState() => new ChatPageState();
}

class ChatPageState extends State<ChatPage> with AfterLayoutMixin {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  ChatProvider chatProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder:
        (BuildContext context, ChatProvider chatProvider, Widget child) {
      return chatProvider.isLoading
          ? Center(
              child: SizedBox(
                  height: 50, width: 50, child: CircularProgressIndicator()))
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: chatProvider.chats.length,
              itemBuilder: (BuildContext context, int index) {
                ChatModel chat = chatProvider.chats[index];
                return ChatWidget(chat: chat);
              },
            );
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.clear();
    chatProvider.load(context);
  }
}
