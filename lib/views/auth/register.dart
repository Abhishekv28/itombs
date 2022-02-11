import 'dart:io';

import 'package:itombs/library.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key});

  @override
  RegisterPageState createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController rpwdController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode pwdFocus = FocusNode();
  FocusNode rpwdFocus = FocusNode();
  bool isFirst = true;
  bool isCheckedPrivacy = false;
  String profileImagePath = '';

  static const double padding = 30, width = 250;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MyTextButton(
                label: 'Back',
                icon: Icons.arrow_back_ios,
                fontWeight: FontWeight.normal,
                action: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: max(MediaQuery.of(context).size.height, 900.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 300,
                      height: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/graphics/logo.png', height: 85),
                            const SizedBox(width: 20),
                            Expanded(
                                child: const Text(
                              'Create Your Account',
                              maxLines: 2,
                              style: TextStyle(
                                  color: AppColors.darkBase,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 35),
                            )),
                          ])),
                  Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: ShadowBox(
                        height: 650,
                        width: 350,
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet<int>(
                                        backgroundColor: Colors.transparent,
                                        barrierColor: AppColors.textHintColor
                                            .withOpacity(0.5),
                                        context: context,
                                        builder: (context) {
                                          return BottomSheetMenu(
                                              length: 2,
                                              title:
                                                  'Please take card photo from',
                                              labels: [
                                                'Gallery',
                                                'Camera'
                                              ],
                                              icons: [
                                                Icons.photo_album,
                                                Icons.camera
                                              ],
                                              actions: [
                                                () async {
                                                  profileImagePath =
                                                      await UtilProvider()
                                                          .getImage(false);

                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                () async {
                                                  profileImagePath =
                                                      await UtilProvider()
                                                          .getImage(true);

                                                  Navigator.pop(context);
                                                  setState(() {});
                                                }
                                              ]);
                                        },
                                      );
                                    },
                                    child: profileImagePath.isEmpty
                                        ? Image.asset(
                                            'assets/graphics/add_photo.png')
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: new Image(
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.fill,
                                                image: FileImage(
                                                    File(profileImagePath))),
                                          )),
                                const SizedBox(height: padding),
                                AuthInputWidget(
                                    width: width,
                                    height: 50,
                                    focusNode: nameFocus,
                                    controller: nameController,
                                    isNullStr:
                                        !isFirst && nameController.text.isEmpty,
                                    label: 'Full Name',
                                    icon: FontAwesomeIcons.userAlt),
                                const SizedBox(height: padding),
                                AuthInputWidget(
                                    width: width,
                                    height: 50,
                                    focusNode: emailFocus,
                                    controller: emailController,
                                    isNullStr: !isFirst &&
                                        emailController.text.isEmpty,
                                    label: 'Email',
                                    icon: Icons.mail),
                                const SizedBox(height: padding),
                                AuthInputWidget(
                                    width: width,
                                    height: 50,
                                    focusNode: pwdFocus,
                                    controller: pwdController,
                                    label: 'Password',
                                    isPassword: true,
                                    isNullStr:
                                        !isFirst && pwdController.text.isEmpty,
                                    icon: FontAwesomeIcons.key,
                                    isHasSuffix: true),
                                const SizedBox(height: padding),
                                AuthInputWidget(
                                  width: width,
                                  height: 50,
                                  focusNode: rpwdFocus,
                                  controller: rpwdController,
                                  label: 'Confirm Password',
                                  isPassword: true,
                                  isNullStr:
                                      !isFirst && rpwdController.text.isEmpty,
                                  icon: FontAwesomeIcons.key,
                                ),
                                const SizedBox(height: padding),
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: AppColors.base,
                                        value: isCheckedPrivacy,
                                        onChanged: (val) {
                                          setState(() {
                                            isCheckedPrivacy = val;
                                          });
                                        },
                                      ),
                                      Expanded(
                                          child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: AppColors.textHintColor,
                                              fontSize: 15.0),
                                          children: <TextSpan>[
                                            TextSpan(text: 'I agree to the '),
                                            TextSpan(
                                                text: 'Terms & Conditions',
                                                style: TextStyle(
                                                    color: AppColors.base,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                            context,
                                                            PageTransition(
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                        AppConstants
                                                                            .timeOfPagination),
                                                                type: AppConstants
                                                                    .typeOfPagination,
                                                                child: ForgotPage(
                                                                    page:
                                                                        'terms')));
                                                      }),
                                            TextSpan(text: ' and '),
                                            TextSpan(
                                                text: 'Privacy Policy',
                                                style: TextStyle(
                                                    color: AppColors.base,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                            context,
                                                            PageTransition(
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                        AppConstants
                                                                            .timeOfPagination),
                                                                type: AppConstants
                                                                    .typeOfPagination,
                                                                child: ForgotPage(
                                                                    page:
                                                                        'privacy')));
                                                      }),
                                          ],
                                        ),
                                      ))
                                    ]),
                                const SizedBox(height: padding),
                                RoundButton(
                                  label: 'Sign Up',
                                  color: AppColors.base,
                                  action: () async {
                                    final name = nameController.text;
                                    final email = emailController.text;
                                    final password = pwdController.text;
                                    final rpassword = rpwdController.text;
                                    if (name.isEmpty ||
                                        email.isEmpty ||
                                        password.isEmpty ||
                                        rpassword.isEmpty) {
                                      setState(() {
                                        isFirst = false;
                                      });
                                      return;
                                    }

                                    FocusScope.of(context).unfocus();

                                    if (!UtilProvider().isEmail(email)) {
                                      UtilProvider()
                                          .showToast(context, 'Invalid email');
                                      return;
                                    }

                                    if (password != rpassword) {
                                      UtilProvider().showToast(
                                          context, 'Password is not match');
                                      return;
                                    }

                                    if (profileImagePath.isEmpty) {
                                      UtilProvider().showToast(
                                          context, 'Please take profile photo');
                                      return;
                                    }

                                    if (!isCheckedPrivacy) {
                                      UtilProvider().showToast(context,
                                          'Please check terms & conditions');
                                      return;
                                    }

                                    String photo = await UtilProvider()
                                        .fileUpload(context, profileImagePath);

                                    await AuthProvider().register(
                                        context, email, name, photo, password);
                                  },
                                ),
                              ],
                            )),
                      )),
                ],
              )),
        ));
  }
}
