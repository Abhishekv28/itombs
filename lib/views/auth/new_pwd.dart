import 'package:itombs/library.dart';

class NewPwdPage extends StatefulWidget {
  final String code;
  final String email;
  final bool isFromForgot;
  NewPwdPage({Key key, this.code = '', this.email, this.isFromForgot = true});

  @override
  NewPwdPageState createState() => new NewPwdPageState();
}

class NewPwdPageState extends State<NewPwdPage> {
  TextEditingController oldController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController rpwdController = TextEditingController();
  FocusNode oldFocus = FocusNode();
  FocusNode pwdFocus = FocusNode();
  FocusNode rpwdFocus = FocusNode();
  bool isFirst = true;

  static const double padding = 80, width = 250;

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
              // Your widgets here
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
                      width: 260,
                      height: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/graphics/logo.png', height: 85),
                            const SizedBox(width: 20),
                            Expanded(
                                child: Text(
                              widget.isFromForgot
                                  ? 'Set New Password'
                                  : 'Change Password',
                              maxLines: 2,
                              style: TextStyle(
                                  color: AppColors.darkBase,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 35),
                            )),
                          ])),
                  Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 30),
                      child: ShadowBox(
                        height: widget.isFromForgot ? 350 : 400,
                        width: 350,
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AuthInputWidget(
                                    width: width,
                                    height: 50,
                                    focusNode: oldFocus,
                                    controller: oldController,
                                    isNullStr:
                                        !isFirst && oldController.text.isEmpty,
                                    label: 'Old Password',
                                    isPassword: true,
                                    isHasSuffix: true,
                                    icon: FontAwesomeIcons.key),
                                const SizedBox(height: 30),
                                AuthInputWidget(
                                    width: width,
                                    height: 50,
                                    focusNode: pwdFocus,
                                    controller: pwdController,
                                    isNullStr:
                                        !isFirst && pwdController.text.isEmpty,
                                    label: 'New Password',
                                    isPassword: true,
                                    isHasSuffix: true,
                                    icon: FontAwesomeIcons.key),
                                const SizedBox(height: 30),
                                AuthInputWidget(
                                    width: width,
                                    height: 50,
                                    focusNode: rpwdFocus,
                                    controller: rpwdController,
                                    isNullStr:
                                        !isFirst && pwdController.text.isEmpty,
                                    label: 'Confirm Password',
                                    isPassword: true,
                                    isHasSuffix: true,
                                    icon: FontAwesomeIcons.key),
                                const SizedBox(height: padding),
                                RoundButton(
                                  label: widget.isFromForgot
                                      ? 'Update'
                                      : 'Save Password',
                                  color: AppColors.base,
                                  action: () async {
                                    final oldPassword = oldController.text;
                                    final password = pwdController.text;
                                    final rpassword = rpwdController.text;
                                    if ((!widget.isFromForgot &&
                                            oldPassword.isEmpty) ||
                                        password.isEmpty ||
                                        rpassword.isEmpty) {
                                      setState(() {
                                        isFirst = false;
                                      });
                                      return;
                                    }

                                    if (password != rpassword) {
                                      UtilProvider().showToast(
                                          context, 'Password is not match');
                                      return;
                                    }

                                    final status = await AuthProvider()
                                        .changePassword(
                                            context,
                                            widget.isFromForgot
                                                ? widget.email
                                                : AuthProvider.user.email,
                                            password,
                                            verifyCode: widget.code,
                                            oldPassword: oldPassword);
                                    if (status)
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
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
