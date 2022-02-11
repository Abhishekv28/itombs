import 'dart:io';

import 'package:itombs/library.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key});

  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode pwdFocus = FocusNode();
  bool isFirst = true;
  final double socialSize = 55;

  @override
  void initState() {
    super.initState();
    // emailController.text = 'oniangel129@gmail.com';
    // pwdController.text = 'qwerty';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: max(MediaQuery.of(context).size.height, 900.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/graphics/logo.png', height: 115),
                  const Text(
                    Strings.title,
                    style: TextStyle(
                        color: AppColors.darkBase,
                        fontWeight: FontWeight.bold,
                        fontSize: 65),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: ShadowBox(
                        height: 380,
                        width: 350,
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AuthInputWidget(
                                    width: 250,
                                    height: 50,
                                    focusNode: emailFocus,
                                    controller: emailController,
                                    isNullStr: !isFirst &&
                                        emailController.text.isEmpty,
                                    label: 'Email',
                                    icon: FontAwesomeIcons.userAlt),
                                const SizedBox(height: 20),
                                AuthInputWidget(
                                    width: 250,
                                    height: 50,
                                    focusNode: pwdFocus,
                                    controller: pwdController,
                                    label: 'Password',
                                    isPassword: true,
                                    isNullStr:
                                        !isFirst && pwdController.text.isEmpty,
                                    icon: FontAwesomeIcons.key,
                                    isHasSuffix: true,
                                    iconSuffix: FontAwesomeIcons.questionCircle,
                                    action: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              duration: const Duration(
                                                  milliseconds: AppConstants
                                                      .timeOfPagination),
                                              type:
                                                  AppConstants.typeOfPagination,
                                              child: ForgotPage()));
                                    }),
                                const SizedBox(height: 30),
                                RoundButton(
                                  label: 'Log In',
                                  color: AppColors.base,
                                  action: () async {
                                    final email = emailController.text;
                                    final password = pwdController.text;
                                    if (email.isEmpty || password.isEmpty) {
                                      setState(() {
                                        isFirst = false;
                                      });
                                      return;
                                    }
                                    FocusScope.of(context).unfocus();
                                    await AuthProvider()
                                        .login(context, email, password);
                                  },
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          height: 1,
                                          child: Divider(
                                              color: AppColors.textHintColor),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text(
                                              'or',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      AppColors.textHintColor),
                                            )),
                                        SizedBox(
                                          width: 100,
                                          height: 1,
                                          child: Divider(
                                              color: AppColors.textHintColor),
                                        ),
                                      ],
                                    )),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (Platform.isIOS)
                                        MaterialButton(
                                            onPressed: () async {
                                              await AuthProvider()
                                                  .appleSign(context);
                                            },
                                            padding: const EdgeInsets.all(0),
                                            child: ShadowBox(
                                              width: socialSize,
                                              height: socialSize,
                                              radius: 30,
                                              depth: 2,
                                              child: Icon(
                                                  FontAwesomeIcons.apple,
                                                  size: 30),
                                            )),
                                      MaterialButton(
                                          onPressed: () async {
                                            await AuthProvider()
                                                .facebookSign(context);
                                          },
                                          padding: const EdgeInsets.all(0),
                                          child: ShadowBox(
                                            width: socialSize,
                                            height: socialSize,
                                            radius: 30,
                                            depth: 2,
                                            child: Icon(
                                                FontAwesomeIcons.facebookF,
                                                color: Colors.blue,
                                                size: 25),
                                          )),
                                      MaterialButton(
                                          onPressed: () async {
                                            await AuthProvider()
                                                .googleSign(context);
                                          },
                                          padding: const EdgeInsets.all(0),
                                          child: ShadowBox(
                                            width: socialSize,
                                            height: socialSize,
                                            radius: 30,
                                            depth: 2,
                                            child: Icon(FontAwesomeIcons.google,
                                                color: Colors.red, size: 25),
                                          ))
                                    ])
                              ],
                            )),
                      )),
                  Text(
                    'New to iTombs?',
                    style: TextStyle(color: AppColors.textHintColor),
                  ),
                  const SizedBox(height: 10),
                  RoundButton(
                      label: 'Sign Up',
                      color: AppColors.base,
                      isFill: false,
                      action: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: const Duration(
                                    milliseconds:
                                        AppConstants.timeOfPagination),
                                type: AppConstants.typeOfPagination,
                                child: RegisterPage()));
                      })
                ],
              )),
        ));
  }
}
