import 'package:itombs/library.dart';

class TutorialPage extends StatefulWidget {
  TutorialPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new TutorialPageState();
}

class TutorialPageState extends State<TutorialPage> {
  PageController pageController =
      PageController(initialPage: 0, keepPage: false);
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(alignment: Alignment.topCenter, children: [
          PageView(
              controller: pageController,
              allowImplicitScrolling: true,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {},
              children:
                  //pages
                  <Widget>[bodyView(0), bodyView(1), bodyView(2), bodyView(3)]),
          if (pageIndex != 3)
            Padding(
                padding: EdgeInsets.only(top: 40, right: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextButton(
                        label: 'BACK',
                        color: Colors.white,
                        action: () {
                          pageIndex--;
                          if (pageIndex < 0) {
                            Navigator.pop(context);
                          } else {
                            pageController.animateToPage(pageIndex,
                                duration: Duration(
                                    milliseconds:
                                        AppConstants.timeOfPagination),
                                curve: Curves.easeIn);
                            setState(() {});
                          }
                        }),
                    MyTextButton(
                        label: 'SKIP',
                        color: Colors.white,
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
                        })
                  ],
                )),
          Padding(
              padding: EdgeInsets.only(top: 450),
              child: SmoothPageIndicator(
                  controller: pageController,
                  count: 4,
                  effect: WormEffect(activeDotColor: AppColors.base),
                  onDotClicked: (index) {})),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: RoundButton(
                    label: pageIndex == 3 ? 'GET STARTED' : 'NEXT',
                    action: () {
                      pageIndex++;
                      if (pageIndex > 3) {
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
                      } else {
                        pageController.animateToPage(pageIndex,
                            duration: Duration(
                                milliseconds: AppConstants.timeOfPagination),
                            curve: Curves.easeIn);
                        setState(() {});
                      }
                    },
                  )))
        ]));
  }

  Widget bodyView(int index) {
    String image, title, content;
    switch (index) {
      case 0:
        image = 'assets/graphics/tuto_welcome.png';
        title = 'Welcome';
        content =
            'iTombs allows you to keep a virtual time capsule for the loved ones in your life who have passed away.';
        break;
      case 1:
        image = 'assets/graphics/tuto_create.png';
        title = 'Create';
        content =
            'Upload photos, videos, letters, & more dedicated to your friends and family that will be released to them after you pass.';
        break;
      case 2:
        image = 'assets/graphics/tuto_upkeep.png';
        title = 'Upkeep';
        content =
            'Friends & family can upkeep your legacy of their loved ones by uploading content & updates through the years.';
        break;
      default:
        image = 'assets/graphics/tuto_qr.png';
        title = 'QR Codes';
        content =
            'Create a QR code that takes anyone who comes across it to the feed, allowing them to get a glimpse into the person’s life.';
        break;
    }
    return Stack(alignment: Alignment.topCenter, children: [
      Column(
        children: [
          CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 450),
              painter: CurvedPainter(totuIndex: pageIndex)),
          const SizedBox(height: 50),
          Text(
            title,
            style: TextStyle(
                color: AppColors.darkBase,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ))
        ],
      ),
      Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Image.asset(
            image,
            height: 220,
          )),
    ]);
  }
}
