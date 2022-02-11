import 'package:flutter/cupertino.dart';
import 'package:itombs/library.dart';

class ChatWidget extends StatelessWidget {
  final ChatModel chat;
  ChatWidget({Key key, this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<UserModel> users = chat.users;
    final list = chat.users
        .where((element) => element.id == AuthProvider.user.id)
        .toList();
    if (list.isNotEmpty) {
      users.remove(list.first);
    }

    final user = users.first;
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
            onTap: () {
              ChatProvider.selectedChat = chat;
              Navigator.push(
                  context,
                  PageTransition(
                      duration: const Duration(
                          milliseconds: AppConstants.timeOfPagination),
                      type: AppConstants.typeOfPagination,
                      child: MessagePage(chat: chat)));
            },
            child: ShadowBox(
                height: 80,
                width: double.infinity,
                child: Row(children: [
                  const SizedBox(width: 10),
                  CacheImageWidget(
                      size: 45, url: user.photo, radius: 8, padding: 40),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Row(children: [
                          Expanded(
                              child: Text(
                            user.name,
                            style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                chat.messages.isEmpty
                                    ? 'UNKNOWN'
                                    : UtilProvider().getTimeString(
                                        chat.messages.first.time),
                                style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          )
                        ]),
                        Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 0),
                            child: Text(
                              chat.messages.isEmpty
                                  ? 'UNKNOWN'
                                  : chat.messages.first.message,
                              style: TextStyle(
                                  color: AppColors.textHintColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300),
                            )),
                      ])),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 17,
                            color: AppColors.textHintColor,
                          )))
                ]))));
  }
}
