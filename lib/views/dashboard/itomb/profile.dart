import 'package:itombs/library.dart';
import 'package:itombs/views/dashboard/widgets/tabbar.dart';

class ItombProfilePage extends StatefulWidget {
  final bool isMini;
  final ItombModel itomb;
  ItombProfilePage({Key key, this.itomb, this.isMini});

  @override
  ItombProfilePageState createState() => new ItombProfilePageState();
}

class ItombProfilePageState extends State<ItombProfilePage>
    with AfterLayoutMixin {
  ItombProvider itombProvider;
  PostProvider postProvider;
  TabController tabbar;
  int indexOfTab = 0;

  @override
  void initState() {
    super.initState();
    itombProvider = Provider.of<ItombProvider>(context, listen: false);
    postProvider = Provider.of<PostProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                            mainAxisAlignment: UtilProvider()
                                    .isMe(context, widget.itomb.userId)
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.start,
                            children: [
                              MyTextButton(
                                label: UtilProvider.selectedPageIndex == 1
                                    ? 'My iTombs'
                                    : 'iTombs',
                                icon: Icons.arrow_back_ios,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                align: MainAxisAlignment.start,
                                action: () {
                                  postProvider.clear();
                                  Navigator.pop(context);
                                },
                              ),
                              if (UtilProvider()
                                  .isMe(context, widget.itomb.userId))
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
                                              padding:
                                                  EdgeInsets.only(right: 23),
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
                                                    height: 150.0,
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
                                                                topLeft:
                                                                    Radius
                                                                        .circular(
                                                                            8),
                                                                bottomLeft:
                                                                    Radius
                                                                        .circular(
                                                                            8),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        8))),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        MyTextButton(
                                                            icon:
                                                                Icons.group_add,
                                                            label:
                                                                ' Manage Admins',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            align:
                                                                MainAxisAlignment
                                                                    .start,
                                                            fontSize: 15,
                                                            iconSize: 18,
                                                            color: AppColors
                                                                .textColor,
                                                            action: () {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      duration: const Duration(
                                                                          milliseconds: AppConstants
                                                                              .timeOfPagination),
                                                                      type: AppConstants
                                                                          .typeOfPagination,
                                                                      child: MembersPage(
                                                                          itomb:
                                                                              widget.itomb)));
                                                            }),
                                                        MyTextButton(
                                                            icon: Icons.edit,
                                                            label:
                                                                ' Edit iTomb',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 15,
                                                            iconSize: 18,
                                                            align:
                                                                MainAxisAlignment
                                                                    .start,
                                                            color: AppColors
                                                                .textColor,
                                                            action: () {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      duration: const Duration(
                                                                          milliseconds: AppConstants
                                                                              .timeOfPagination),
                                                                      type: AppConstants
                                                                          .typeOfPagination,
                                                                      child: ItombCreatePage(
                                                                          itomb:
                                                                              widget.itomb)));
                                                            }),
                                                        MyTextButton(
                                                            icon: Icons.delete,
                                                            label:
                                                                ' Delete iTomb',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 15,
                                                            iconSize: 18,
                                                            align:
                                                                MainAxisAlignment
                                                                    .start,
                                                            color: AppColors
                                                                .textColor,
                                                            iconColor:
                                                                Colors.red,
                                                            action: () {
                                                              Navigator.pop(
                                                                  context);
                                                              UtilProvider()
                                                                  .showAlertDialog(
                                                                      context:
                                                                          context,
                                                                      title:
                                                                          'Delete iTomb',
                                                                      content:
                                                                          'Are you sure you want to delete this iTomb and all videos on it?',
                                                                      defaultActionText:
                                                                          'Yes, Delete',
                                                                      cancelActionText:
                                                                          'Cancel',
                                                                      defaultAction:
                                                                          () async {
                                                                        await itombProvider.remove(
                                                                            context,
                                                                            widget.itomb.id);
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
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
                    Padding(
                        padding: EdgeInsets.only(top: 15, left: 140),
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.itomb.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                        color: Colors.white)),
                                const SizedBox(height: 5),
                                Text(
                                    '${UtilProvider().getTimeString(widget.itomb.dateOfBirth)} - ${UtilProvider().getTimeString(widget.itomb.dateOfPass)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: Colors.white)),
                              ],
                            )),
                            Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: GestureDetector(
                                    onTap: () {
                                      showQRCode(widget.itomb.qrCodeLink);
                                    },
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.white,
                                            padding: const EdgeInsets.all(5),
                                            child: Center(
                                                child: QrImage(
                                              data: widget.itomb.qrCodeLink,
                                              version: QrVersions.auto,
                                              padding: const EdgeInsets.all(0),
                                              size: 50.0,
                                            ))))))
                          ],
                        )),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(top: 100, left: 10),
                child: CacheImageWidget(
                    url: widget.itomb.photo, size: 120, radius: 10)),
            Padding(
                padding: const EdgeInsets.only(top: 175, left: 120),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  RoundButton(
                    label: 'Leave Group',
                    color: Colors.grey[600],
                    width: 100,
                    height: 30,
                    isFill: false,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    borderWidth: 1.5,
                    action: () async {
                      UtilProvider().showAlertDialog(
                          context: context,
                          title: 'Leave Group',
                          content: 'Are you sure you want to leave this group?',
                          defaultActionText: 'Yes, Leave',
                          cancelActionText: 'Cancel',
                          defaultAction: () async {
                            itombProvider.leave(context, widget.itomb.id);
                            Navigator.pop(context);
                          });
                    },
                  ),
                  RoundButton(
                    label: 'Add Post',
                    width: 100,
                    height: 30,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: AppColors.base,
                    action: () async {
                      Navigator.push(
                          context,
                          PageTransition(
                              duration: const Duration(
                                  milliseconds: AppConstants.timeOfPagination),
                              type: AppConstants.typeOfPagination,
                              child: PostCreatePage(itomb: widget.itomb)));
                    },
                  )
                ]))
          ]),
          Padding(
              padding: const EdgeInsets.only(
                  right: 10, left: 10, top: 20, bottom: 20),
              child: Text(widget.itomb.bio,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.textColor))),
          RoundButton(
            label: 'In lieu of gifts, please click to donate to this charity.',
            width: MediaQuery.of(context).size.width - 20,
            height: 45,
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColors.base,
            action: () async {},
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: RoundButton(
              icon: Icons.videocam,
              label: 'View Mandy’s Videos',
              width: double.infinity,
              height: 45,
              isFill: false,
              fontWeight: FontWeight.w500,
              fontSize: 13,
              iconSize: 20,
              color: AppColors.base,
              action: () {
                Navigator.push(
                    context,
                    PageTransition(
                        duration: const Duration(
                            milliseconds: AppConstants.timeOfPagination),
                        type: AppConstants.typeOfPagination,
                        child: VideosPage(itomb: widget.itomb)));
              },
            ),
          ),
          Expanded(
              child: !widget.isMini
                  ? TabbarView(
                      controller: tabbar,
                      length: 2,
                      currentIndex: indexOfTab,
                      labels: [
                          'Mini iTombs',
                          'Posts'
                        ],
                      widgets: [
                          Consumer<ItombProvider>(builder:
                              (BuildContext context,
                                  ItombProvider itombProvider, Widget child) {
                            return itombProvider.isLoading
                                ? Center(
                                    child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator()))
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.all(10),
                                    itemCount:
                                        itombProvider.allItombs.length + 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      List<ItombModel> itombs =
                                          UtilProvider.selectedPageIndex == 1
                                              ? itombProvider.myItombs
                                              : itombProvider.allItombs;
                                      if (index < itombs.length) {
                                        ItombModel itomb = itombs[index];
                                        return ItombWidget(
                                          itomb: itomb,
                                          isMini: true,
                                        );
                                      }
                                      return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 30, bottom: 30),
                                          child: RoundButton(
                                            label: 'Create a Mini iTomb',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                20,
                                            height: 45,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: AppColors.base,
                                            action: () async {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      duration: const Duration(
                                                          milliseconds: AppConstants
                                                              .timeOfPagination),
                                                      type: AppConstants
                                                          .typeOfPagination,
                                                      child:
                                                          ItombCreatePage()));
                                            },
                                          ));
                                    },
                                  );
                          }),
                          Consumer<PostProvider>(builder: (BuildContext context,
                              PostProvider postProvider, Widget child) {
                            if (postProvider.isLoading)
                              return Center(
                                  child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(),
                              ));

                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 0),
                              itemCount: postProvider.posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                PostModel post = postProvider.posts[index];
                                return PostWidget(post: post);
                              },
                            );
                          })
                        ])
                  : Consumer<PostProvider>(builder: (BuildContext context,
                      PostProvider postProvider, Widget child) {
                      if (postProvider.isLoading)
                        return Center(
                            child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ));

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 0),
                        itemCount: postProvider.posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          PostModel post = postProvider.posts[index];
                          return PostWidget(post: post);
                        },
                      );
                    }))
        ]));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final params = {'id': widget.itomb.id};
    postProvider.load(context, params);
  }

  void showQRCode(String code) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.all(10),
                shape: OutlineInputBorder(
                    gapPadding: 0, borderRadius: BorderRadius.circular(12.0)),
                content: Container(
                    width: 250,
                    height: 250,
                    color: Colors.white,
                    child: Center(
                        child: QrImage(
                      data: code,
                      version: QrVersions.auto,
                      padding: const EdgeInsets.all(0),
                      size: 250.0,
                    ))),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomTriangleClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
