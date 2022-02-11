import 'package:flutter/cupertino.dart';
import 'package:itombs/library.dart';

class MemberWidget extends StatefulWidget {
  final ItombModel itomb;
  final UserModel user;
  final bool isForAdd;
  MemberWidget({Key key, this.itomb, this.user, this.isForAdd = true})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new MemberWidgetState();
}

class MemberWidgetState extends State<MemberWidget> {
  MemberProvider memberProvider;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    memberProvider = Provider.of<MemberProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    bool isAlreadyAdded = memberProvider.addedUsers
            .where((element) => element.id == widget.user.id)
            .toList()
            .length >
        0;
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
            onTap: () {
              if (widget.user.id != AuthProvider.user.id)
                Navigator.push(
                    context,
                    PageTransition(
                        duration: const Duration(
                            milliseconds: AppConstants.timeOfPagination),
                        type: AppConstants.typeOfPagination,
                        child: ProfilePage(
                          itomb: widget.itomb,
                          user: widget.user,
                        )));
            },
            child: ShadowBox(
                height: 80,
                width: double.infinity,
                child: Row(children: [
                  const SizedBox(width: 10),
                  CacheImageWidget(
                      size: 60, url: widget.user.photo, radius: 8, padding: 40),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Row(children: [
                          Expanded(
                              child: Text(
                            widget.user.name,
                            style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          )),
                        ]),
                        Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 0),
                            child: Text(
                              widget.user.email,
                              style: TextStyle(
                                  color: AppColors.textHintColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                            )),
                      ])),
                  Align(
                      alignment: widget.isForAdd
                          ? Alignment.center
                          : Alignment.topRight,
                      child: isLoading
                          ? Container(
                              width: 75,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator())))
                          : widget.isForAdd
                              ? RoundButton(
                                  label: isAlreadyAdded ? 'Added' : 'Add',
                                  width: 75,
                                  height: 35,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: isAlreadyAdded
                                      ? Colors.grey
                                      : AppColors.base,
                                  action: () async {
                                    if (isAlreadyAdded) return;
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await memberProvider.add(
                                        context, widget.itomb.id, widget.user);
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    UtilProvider().showAlertDialog(
                                        context: context,
                                        title: 'Delete Member',
                                        content:
                                            'Are you sure you want to delete this member?',
                                        defaultActionText: 'Yes, Delete',
                                        cancelActionText: 'Cancel',
                                        defaultAction: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await memberProvider.remove(context,
                                              widget.itomb.id, widget.user);
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                  }))
                ]))));
  }
}
