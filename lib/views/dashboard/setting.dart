import 'package:itombs/library.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key});

  @override
  SettingPageState createState() => new SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  bool isEnableNoti = true;
  bool isNameEditable = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder:
        (BuildContext context, AuthProvider authProvider, Widget child) {
      nameController.text = AuthProvider.user.name;
      return SingleChildScrollView(
          child: Container(
              height: max(700, MediaQuery.of(context).size.height),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(alignment: Alignment.topLeft, children: [
                      Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xff3A105E), Color(0xff633789)],
                            ),
                          )),
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: CacheImageWidget(
                                  url: AuthProvider.user.photo,
                                  size: 120,
                                  radius: 10))),
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 120, left: 120),
                              child: TextButton(
                                  onPressed: () {
                                    showModalBottomSheet<int>(
                                      backgroundColor: Colors.transparent,
                                      barrierColor: AppColors.textHintColor
                                          .withOpacity(0.5),
                                      context: context,
                                      builder: (context1) {
                                        return BottomSheetMenu(
                                            length: 2,
                                            title: 'Change Profile Picture',
                                            labels: [
                                              'Take Photos',
                                              'Choose from Camera Roll'
                                            ],
                                            icons: [
                                              Icons.photo_album,
                                              Icons.camera
                                            ],
                                            actions: [
                                              () async {
                                                final path =
                                                    await UtilProvider()
                                                        .getImage(false);
                                                Navigator.pop(context1);
                                                if (path.isEmpty) return;
                                                final photo =
                                                    await UtilProvider()
                                                        .fileUpload(
                                                            context, path);
                                                authProvider.updateProfile(
                                                    context,
                                                    photo: photo);
                                              },
                                              () async {
                                                final path =
                                                    await UtilProvider()
                                                        .getImage(true);

                                                Navigator.pop(context1);
                                                if (path.isEmpty) return;
                                                final photo =
                                                    await UtilProvider()
                                                        .fileUpload(
                                                            context, path);
                                                authProvider.updateProfile(
                                                    context,
                                                    photo: photo);
                                              }
                                            ]);
                                      },
                                    );
                                  },
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: AppColors.base,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.white,
                                      ))))),
                    ]),
                    Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            isNameEditable
                                ? SizedBox(
                                    height: 30,
                                    width: 300,
                                    child: TextField(
                                      controller: nameController,
                                      focusNode: nameFocus,
                                      enabled: true,
                                      textAlign: TextAlign.center,
                                      onEditingComplete: () async {
                                        AuthProvider.user.name =
                                            nameController.text;
                                        await AuthProvider().updateProfile(
                                            context,
                                            name: nameController.text);
                                        setState(() {
                                          isNameEditable = false;
                                        });
                                      },
                                      style: TextStyle(
                                        color: AppColors.textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 23,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        const SizedBox(width: 40),
                                        Text(AuthProvider.user.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 23,
                                                color: AppColors.textColor)),
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: Size(20, 20)),
                                            onPressed: () async {
                                              setState(() {
                                                isNameEditable = true;
                                              });
                                              await Future.delayed(
                                                  Duration(milliseconds: 100));
                                              nameController.selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset: nameController
                                                              .text.length));
                                              FocusScope.of(context)
                                                  .requestFocus(nameFocus);
                                            },
                                            child: Icon(Icons.edit,
                                                color: AppColors.base,
                                                size: 20))
                                      ]),
                            const SizedBox(height: 5),
                            Text(AuthProvider.user.email,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                    color: AppColors.textHintColor)),
                          ],
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SETTINGS',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: AppColors.textColor)),
                                const SizedBox(height: 10),
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Notification'),
                                  trailing: Switch(
                                      value: isEnableNoti,
                                      activeColor: AppColors.base,
                                      onChanged: (val) {
                                        setState(() {
                                          isEnableNoti = val;
                                        });
                                      }),
                                ),
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(left: 5, right: 10),
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Change Password'),
                                  trailing:
                                      Icon(Icons.arrow_forward_ios, size: 17),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            duration: const Duration(
                                                milliseconds: AppConstants
                                                    .timeOfPagination),
                                            type: AppConstants.typeOfPagination,
                                            child: NewPwdPage(
                                                isFromForgot: false)));
                                  },
                                ),
                                const SizedBox(height: 20),
                                Text('SUPPORT',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: AppColors.textColor)),
                                const SizedBox(height: 10),
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(left: 5, right: 10),
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('About Us'),
                                  trailing:
                                      Icon(Icons.arrow_forward_ios, size: 17),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            duration: const Duration(
                                                milliseconds: AppConstants
                                                    .timeOfPagination),
                                            type: AppConstants.typeOfPagination,
                                            child: PrivacyPolicyPage(
                                                target: WebviewTag.about)));
                                    // launch(
                                    //     'https://api.itombs.org/static/about-us.html');
                                  },
                                ),
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(left: 5, right: 10),
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Privacy Policy'),
                                  trailing:
                                      Icon(Icons.arrow_forward_ios, size: 17),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            duration: const Duration(
                                                milliseconds: AppConstants
                                                    .timeOfPagination),
                                            type: AppConstants.typeOfPagination,
                                            child: PrivacyPolicyPage(
                                                target: WebviewTag.policy)));
                                    // launch(
                                    //     'https://api.itombs.org/static/privacy-policy.html');
                                  },
                                ),
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(left: 5, right: 10),
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Terms of Service'),
                                  trailing:
                                      Icon(Icons.arrow_forward_ios, size: 17),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            duration: const Duration(
                                                milliseconds: AppConstants
                                                    .timeOfPagination),
                                            type: AppConstants.typeOfPagination,
                                            child: PrivacyPolicyPage(
                                                target: WebviewTag.terms)));
                                    // launch(
                                    //     'https://api.itombs.org/static/terms-and-condition.html');
                                  },
                                ),
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(left: 5, right: 10),
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Send Feedback'),
                                  trailing:
                                      Icon(Icons.arrow_forward_ios, size: 17),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            duration: const Duration(
                                                milliseconds: AppConstants
                                                    .timeOfPagination),
                                            type: AppConstants.typeOfPagination,
                                            child: FeedbackPage()));
                                  },
                                ),
                                const SizedBox(height: 30),
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(right: 10),
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Log Out'),
                                  trailing:
                                      Icon(Icons.arrow_forward_ios, size: 17),
                                  onTap: () async {
                                    await AuthProvider().logOut(context);
                                  },
                                ),
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(right: 10),
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Delete Account'),
                                  trailing:
                                      Icon(Icons.arrow_forward_ios, size: 17),
                                  onTap: () {
                                    UtilProvider().showAlertDialog(
                                        context: context,
                                        title: 'Delete Account',
                                        content:
                                            'Are you sure you want to delete your account?',
                                        defaultActionText: 'Yes, Delete',
                                        cancelActionText: 'Cancel',
                                        defaultAction: () async {
                                          // Navigator.pop(context);
                                        });
                                  },
                                )
                              ],
                            )))
                  ])));
    });
  }
}
