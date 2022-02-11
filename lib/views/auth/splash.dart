import 'package:flutter/services.dart';
import 'package:itombs/library.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(alignment: Alignment.bottomCenter, children: [
          Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/graphics/logo.png',
                    height: 230,
                  ),
                ],
              )),
        ]));
  }

  void init() {
    Future.delayed(const Duration(seconds: 2), () {
      SharedPreferences.getInstance().then((value) async {
        if (value.getBool(Strings.key_tutorial_passed) ?? false) {
          final email = value.getString(Strings.key_auth_email) ?? '';
          final password = value.getString(Strings.key_auth_password) ?? '';
          if (email.isEmpty || password.isEmpty) {
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                    duration: const Duration(
                        milliseconds: AppConstants.timeOfPagination),
                    type: AppConstants.typeOfPagination,
                    child: LoginPage()),
                (route) => false);
          } else {
            final isSocial = value.getBool(Strings.key_auth_is_social) ?? false;
            bool status = false;
            if (isSocial) {
              status = await AuthProvider()
                  .socialSign(context, email, 'x', 'x', password, 'x');
            } else {
              status = await AuthProvider().login(context, email, password);
            }
            if (!status) {
              value.setString(Strings.key_auth_email, '');
              value.setString(Strings.key_auth_password, '');
              value.setBool(Strings.key_auth_is_social, false);
              Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                      duration: const Duration(
                          milliseconds: AppConstants.timeOfPagination),
                      type: AppConstants.typeOfPagination,
                      child: LoginPage()),
                  (route) => false);
            }
          }
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  duration: const Duration(
                      milliseconds: AppConstants.timeOfPagination),
                  type: AppConstants.typeOfPagination,
                  child: WelcomePage()),
              (route) => false);
        }
      });
    });
  }
}
