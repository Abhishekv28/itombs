import 'package:itombs/library.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(alignment: Alignment.bottomCenter, children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: const EdgeInsets.only(top: 40, right: 10),
                  child: MyTextButton(
                      label: 'SKIP',
                      color: Colors.grey[900],
                      action: () {
                        SharedPreferences.getInstance().then((value) {
                          value.setBool(Strings.key_tutorial_passed, true);
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                  duration: const Duration(
                                      milliseconds:
                                          AppConstants.timeOfPagination),
                                  type: AppConstants.typeOfPagination,
                                  child: LoginPage()),
                              (route) => false);
                        });
                      }))),
          Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/graphics/logo.png',
                    height: 230,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      'WELCOME TO',
                      style: TextStyle(
                          color: AppColors.darkBase,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  const Text(
                    Strings.title,
                    style: TextStyle(
                        color: AppColors.darkBase,
                        fontWeight: FontWeight.bold,
                        fontSize: 70),
                  )
                ],
              )),
          Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: RoundButton(
                label: 'NEXT',
                action: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: const Duration(
                              milliseconds: AppConstants.timeOfPagination),
                          type: AppConstants.typeOfPagination,
                          child: TutorialPage()));
                },
              ))
        ]));
  }
}
