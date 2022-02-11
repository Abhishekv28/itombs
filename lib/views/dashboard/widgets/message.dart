import 'package:flutter/cupertino.dart';
import 'package:itombs/library.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  MessageWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMe = message.user.id == AuthProvider.user.id;
    final radius = 8.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe)
                  ClipPath(
                    clipper: CustomTriangleClipper(),
                    child: Container(
                        width: 15, height: 12, color: Colors.grey[300]),
                  ),
                Container(
                    decoration: BoxDecoration(
                        color: isMe ? AppColors.base : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            bottomLeft: Radius.circular(!isMe ? 0 : radius),
                            topRight: Radius.circular(radius),
                            bottomRight: Radius.circular(isMe ? 0 : radius))),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 2 + 30,
                      minWidth: 50.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text(message.message,
                        style: TextStyle(
                            color: isMe ? Colors.white : AppColors.textColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500))),
                if (isMe)
                  if (isMe)
                    ClipPath(
                      clipper: CustomTriangleClipper1(),
                      child: Container(
                          width: 15, height: 12, color: AppColors.base),
                    ),
              ]),
          Padding(
              padding:
                  const EdgeInsets.only(top: 5, bottom: 0, left: 15, right: 15),
              child: Text(
                UtilProvider().getTimeString(message.time),
                style: TextStyle(
                    color: AppColors.textHintColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w300),
              ))
        ],
      ),
    );
  }
}
