import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:itombs/library.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key});

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> with AfterLayoutMixin {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  ItombProvider itombProvider;
  PostProvider postProvider;
  VideoProvider videoProvider;
  ChatProvider chatProvider;
  MessageProvider messageProvider;

  @override
  void initState() {
    super.initState();
    itombProvider = Provider.of<ItombProvider>(context, listen: false);
    postProvider = Provider.of<PostProvider>(context, listen: false);
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    messageProvider = Provider.of<MessageProvider>(context, listen: false);

    initSockets();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UtilProvider>(builder:
        (BuildContext context, UtilProvider utilProvider, Widget child) {
      Widget body;
      String title;
      Color appBarColor = Colors.white;
      Color appBarIconColor = AppColors.base;
      switch (UtilProvider.selectedPageIndex) {
        case 0:
          body = ItombPage();
          title = 'Home';
          break;
        case 1:
          body = ItombPage();
          title = 'My iTombs';
          break;
        case 2:
          body = ChatPage();
          title = 'Messages';
          break;
        case 3:
          body = ScanQRPage();
          title = 'QR Scanner';
          break;
        case 4:
          body = SettingPage();
          title = '';
          appBarColor = AppColors.darkBase;
          appBarIconColor = Colors.white;
          break;
        default:
          body = Container(color: Colors.grey);
          title = 'Nothing';
          break;
      }
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: appBarColor,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MyTextButton(
                  label: '',
                  icon: Icons.menu,
                  iconColor: appBarIconColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 25,
                  align: MainAxisAlignment.start,
                  action: () {
                    drawerKey.currentState.openDrawer();
                  },
                ),
                Expanded(
                    child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.base),
                )),
                MyTextButton(
                  label: '',
                  icon: Icons.notifications,
                  iconColor: appBarIconColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 25,
                  align: MainAxisAlignment.end,
                  action: () {},
                )
              ],
            ),
          ),
          key: drawerKey,
          drawer: DrawerWidget(),
          backgroundColor: Colors.white,
          body: body);
    });
  }

  void initSockets() {
    Operation likeOperation = Operation(
        documentNode: gql(Queries.toggledLikeSocket),
        operationName: 'toggledLike');
    Stream<FetchResult> likeSubscriptionResult =
        UtilProvider.gqClient.subscribe(likeOperation);

    if (likeSubscriptionResult != null) {
      likeSubscriptionResult.listen((messages) {
        if (messages.data != null) {
          final type = messages.data['toggledLike']['tag'];
          final targetID = messages.data['toggledLike']['tag_id'];
          final likedNum = messages.data['toggledLike']['likeCount'];
          switch (type) {
            case 'post':
              postProvider.updateLikedNum(likedNum, targetID);
              break;
            case 'video':
              videoProvider.updateLikedNum(likedNum, targetID);
              break;
            default:
              break;
          }
        }
      }, onError: (e) {
        print("error: $e");
      }, cancelOnError: true);
    }

    Operation chatOperation = Operation(
        documentNode: gql(Queries.addChatSocket),
        operationName: 'messageThreadAdded');
    Stream<FetchResult> chatSocketResult =
        UtilProvider.gqClient.subscribe(chatOperation);

    if (chatSocketResult != null) {
      chatSocketResult.listen((result) {
        if (result.data['messageThreadAdded'] != null) {
          chatProvider.updateList(
              ChatModel.fromJson(result.data['messageThreadAdded']));
        }
      }, onError: (e) {
        print("error: $e");
      }, cancelOnError: true);
    }

    Operation msgOperation = Operation(
        documentNode: gql(Queries.addMessageSocket),
        operationName: 'messageAdded');
    Stream<FetchResult> msgSocketResult =
        UtilProvider.gqClient.subscribe(msgOperation);
        
    if (msgSocketResult != null) {
      msgSocketResult.listen((result) {
        if (result.data['messageAdded'] != null) {
          MessageModel message =
              MessageModel.fromJson(result.data['messageAdded']);
          chatProvider.updateListWithMessage(message);

          if ((ChatProvider.selectedChat != null) &&
              (ChatProvider.selectedChat.id == message.chatID)) {
            messageProvider.updateListWithMessage(message);
          }
        }
      }, onError: (e) {
        print("error: $e");
      }, cancelOnError: true);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    itombProvider = Provider.of<ItombProvider>(context, listen: false);
    itombProvider.load(context);
  }
}
