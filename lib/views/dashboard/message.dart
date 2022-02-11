import 'package:itombs/library.dart';

class MessagePage extends StatefulWidget {
  final ChatModel chat;

  MessagePage({Key key, this.chat});

  @override
  MessagePageState createState() => new MessagePageState();
}

class MessagePageState extends State<MessagePage> with AfterLayoutMixin {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  MessageProvider messageProvider;
  TextEditingController msgController = TextEditingController();
  FocusNode msgFocus = FocusNode();
  ScrollController scrollController = ScrollController();
  UserModel user;

  @override
  void initState() {
    super.initState();
    List<UserModel> users = widget.chat.users;
    final list = widget.chat.users
        .where((element) => element.id == AuthProvider.user.id)
        .toList();
    if (list.isNotEmpty) {
      users.remove(list.first);
    }
    user = users.first;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(builder:
        (BuildContext context, MessageProvider messageProvider, Widget child) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MyTextButton(
                  label: 'Back',
                  icon: Icons.arrow_back_ios,
                  fontWeight: FontWeight.normal,
                  align: MainAxisAlignment.start,
                  action: () {
                    messageProvider.clear();
                    ChatProvider.selectedChat = null;
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                    child: Text(
                  user.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.base),
                )),
                MyTextButton(
                  label: '',
                  icon: null,
                  fontWeight: FontWeight.normal,
                  fontSize: 25,
                  align: MainAxisAlignment.end,
                  action: () {},
                )
              ],
            ),
          ),
          key: drawerKey,
          backgroundColor: Colors.white,
          body: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                  child: messageProvider.isLoading
                      ? Center(
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator()))
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(10),
                          reverse: true,
                          itemCount: messageProvider.messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            MessageModel message =
                                messageProvider.messages[index];
                            return MessageWidget(message: message);
                          },
                        )),
              Container(
                color: Colors.grey,
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: TextFormField(
                      controller: msgController,
                      focusNode: msgFocus,
                      textAlign: TextAlign.start,
                      maxLength: null,
                      textInputAction: TextInputAction.send,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        if (msgController.text.isEmpty) return;

                        messageProvider.add(msgController.text, widget.chat.id);
                        // MessageModel message = MessageModel(
                        //     id: Random().nextInt(100).toString(),
                        //     senderId: isMe
                        //         ? AuthProvider.user.id
                        //         : widget.chat.user.id,
                        //     receiverId: isMe
                        //         ? AuthProvider.user.id
                        //         : Random().nextInt(10).toString(),
                        //     message: msgController.text,
                        //     time: '2021-10-${Random().nextInt(30)}');
                        // messageProvider.add(message);
                        msgController.text = '';
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent + 50,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn,
                        );
                      },
                      style:
                          TextStyle(color: AppColors.textColor, fontSize: 17),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          hintText: 'Type...',
                          border: InputBorder.none,
                          labelStyle: TextStyle(
                              color: AppColors.textHintColor, fontSize: 15))),
                ),
              )
            ],
          ));
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    messageProvider = Provider.of<MessageProvider>(context, listen: false);
    final param = {
      'thread': widget.chat.id,
      'limit': 1000,
      'sort': {'feature': 'CREATED_AT', 'type': 'DESC'}
    };
    messageProvider.load(context, param);
  }
}
