import 'package:itombs/library.dart';

class ForgotPage extends StatefulWidget {
  final String page;
  ForgotPage({Key key, this.page = 'forgot'});

  @override
  ForgotPageState createState() => new ForgotPageState();
}

class ForgotPageState extends State<ForgotPage> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  bool isFirst = true;

  static const double padding = 80, width = 250;

  @override
  Widget build(BuildContext context) {
    String title, bodyStr;
    double titleWidth = 300;

    switch (widget.page) {
      case 'terms':
        title = 'Terms & Conditions';
        bodyStr = 'Here is body for Terms & Conditions';
        titleWidth = 280;
        break;
      case 'privacy':
        title = 'Privacy Policy';
        bodyStr = 'Here is body for Privacy Policy';
        titleWidth = 230;
        break;
      default:
        title = 'Forgot Your Password?';
        bodyStr =
            'Please enter the email address associated with your account. We will email you a code to reset your password.';
        titleWidth = 300;
        break;
    }
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
                      width: titleWidth,
                      height: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/graphics/logo.png', height: 85),
                            const SizedBox(width: 20),
                            Expanded(
                                child: Text(
                              title,
                              maxLines: 2,
                              style: TextStyle(
                                  color: AppColors.darkBase,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 35),
                            )),
                          ])),
                  Padding(
                      padding: EdgeInsets.only(
                          left: widget.page == 'forgot' ? 40 : 20,
                          right: widget.page == 'forgot' ? 40 : 20,
                          top: 30),
                      child: Text(
                        bodyStr,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      )),
                  if (widget.page == 'forgot')
                    Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 30),
                        child: ShadowBox(
                          height: 300,
                          width: 350,
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                  RoundButton(
                                    label: 'Send Reset Email',
                                    color: AppColors.base,
                                    action: () async {
                                      final email = emailController.text;
                                      if (email.isEmpty) {
                                        setState(() {
                                          isFirst = false;
                                        });
                                        return;
                                      }

                                      if (!UtilProvider().isEmail(email)) {
                                        UtilProvider().showToast(
                                            context, 'Invalid email');
                                        return;
                                      }

                                      String code = await AuthProvider()
                                          .requestResetPassword(context, email);
                                      if (code.isNotEmpty)
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                duration: const Duration(
                                                    milliseconds: AppConstants
                                                        .timeOfPagination),
                                                type: AppConstants
                                                    .typeOfPagination,
                                                child: ForgotCodeVerifyPage(
                                                    code: code, email: email)));
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
