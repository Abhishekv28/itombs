import 'package:itombs/library.dart';

class FullPhotoScreen extends StatefulWidget {
  final List<String> photos;
  final int index;

  FullPhotoScreen({Key key, this.photos, this.index = 0}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new FullPhotoScreenState();
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  // YoutubePlayerController youtubeController;
  int index = 0;
  PageController pageController;
  @override
  void initState() {
    super.initState();
    index = widget.index;
    pageController = PageController(initialPage: index, keepPage: false);
  }

  @override
  dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      child: Stack(alignment: Alignment.topRight, children: [
        PageView(
            controller: pageController,
            allowImplicitScrolling: true,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {},
            children: <Widget>[
              for (String photo in widget.photos)
                PhotoView(
                  loadingBuilder: (context, evemt) =>
                      Center(child: CircularProgressIndicator()),
                  imageProvider: CachedNetworkImageProvider(photo),
                ),
            ]),
        Padding(
            padding: EdgeInsets.only(top: 40, right: 10),
            child: RawMaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              fillColor: Colors.white.withOpacity(0.5),
              child: const Icon(
                Icons.close,
                size: 25.0,
                color: Colors.white,
              ),
              constraints: const BoxConstraints(maxWidth: 50, maxHeight: 50),
              padding: const EdgeInsets.all(5),
              shape: CircleBorder(),
            )),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: SmoothPageIndicator(
                    controller: pageController, // PageController
                    count: widget.photos.length,
                    effect: WormEffect(
                        activeDotColor: Colors.blue), // your preferred effect
                    onDotClicked: (index) {
                      pageController.animateToPage(index,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeIn);
                    })))
      ]),
      onSwipeDown: () {
        Navigator.pop(context);
      },
      onSwipeRight: () {
        setState(() {
          if (index > 0) {
            index -= 1;
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 100), curve: Curves.easeIn);
          }
          print(index);
        });
      },
      onSwipeLeft: () {
        setState(() {
          if (index < widget.photos.length - 1) {
            index += 1;
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 100), curve: Curves.easeIn);
          }
          print(index);
        });
      },
    );
  }
}
