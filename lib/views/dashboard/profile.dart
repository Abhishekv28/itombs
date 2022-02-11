import 'package:itombs/library.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  final ItombModel itomb;
  ProfilePage({Key key, this.user, this.itomb});

  @override
  ProfilePageState createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  ChatProvider chatProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Stack(alignment: Alignment.topLeft, children: [
            Container(
                height: 170,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff3A105E), Color(0xff633789)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top, left: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyTextButton(
                                label: widget.itomb.name,
                                icon: Icons.arrow_back_ios,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                align: MainAxisAlignment.start,
                                action: () {
                                  Navigator.pop(context);
                                },
                              ),
                              MyTextButton(
                                icon: Icons.more_vert,
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                align: MainAxisAlignment.start,
                                action: () {
                                  Dialog errorDialog = Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding:
                                          EdgeInsets.only(top: 40, right: 0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                            padding: EdgeInsets.only(right: 23),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                ClipPath(
                                                  clipper:
                                                      CustomTriangleClipper(),
                                                  child: Container(
                                                      width: 20,
                                                      height: 15,
                                                      color: Colors.white),
                                                ),
                                                Container(
                                                  height: 60.0,
                                                  width: 160.0,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(8),
                                                              bottomLeft: Radius
                                                                  .circular(8),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      MyTextButton(
                                                          icon: Icons
                                                              .report_problem_outlined,
                                                          label: ' Report User',
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 15,
                                                          iconSize: 18,
                                                          align:
                                                              MainAxisAlignment
                                                                  .start,
                                                          color: AppColors
                                                              .textColor,
                                                          iconColor: Colors.red,
                                                          action: () {
                                                            Navigator.pop(
                                                                context);
                                                            UtilProvider().showAlertDialog(
                                                                context:
                                                                    context,
                                                                title:
                                                                    'Report User',
                                                                content:
                                                                    'Are you sure you want to report this user?',
                                                                defaultActionText:
                                                                    'Yes, Report',
                                                                cancelActionText:
                                                                    'Cancel',
                                                                defaultAction:
                                                                    () async {});
                                                          }),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      ));
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          errorDialog);
                                },
                              )
                            ])),
                  ],
                )),
            Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: CacheImageWidget(
                        url: widget.user.photo, size: 120, radius: 10))),
          ]),
          Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.user.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 23,
                          color: AppColors.textColor)),
                  const SizedBox(height: 5),
                  Text(widget.user.email,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          color: AppColors.textHintColor)),
                ],
              )),
          RoundButton(
            icon: Icons.message,
            label: 'Message ${widget.user.name}',
            width: 300,
            height: 45,
            isFill: true,
            fontWeight: FontWeight.w500,
            fontSize: 13,
            iconSize: 20,
            color: AppColors.base,
            action: () async {
              UtilProvider().showProgressing(context);
              ChatModel chat = await chatProvider.add(widget.user.id);
              Navigator.pop(context);
              ChatProvider.selectedChat = chat;
              Navigator.push(
                  context,
                  PageTransition(
                      duration: const Duration(
                          milliseconds: AppConstants.timeOfPagination),
                      type: AppConstants.typeOfPagination,
                      child: MessagePage(chat: chat)));
            },
          ),
        ]));
  }
}
