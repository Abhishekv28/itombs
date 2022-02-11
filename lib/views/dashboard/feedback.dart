import 'dart:io';

import 'package:itombs/library.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({Key key});

  @override
  FeedbackPageState createState() => new FeedbackPageState();
}

class FeedbackPageState extends State<FeedbackPage> {
  TextEditingController feedController = TextEditingController();
  FocusNode feedFocus = FocusNode();
  List<String> pathOfPhotos = [];
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 280,
                      height: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/graphics/logo.png', height: 85),
                            const SizedBox(width: 20),
                            Expanded(
                                child: Text(
                              'Send Us Feedback',
                              maxLines: 2,
                              style: TextStyle(
                                  color: AppColors.darkBase,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 35),
                            )),
                          ])),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        'Leave your feedback, suggestions, and issues for iTombs below. We’d love to hear from you!',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            height: 1.5,
                            color: AppColors.textHintColor,
                            fontSize: 13),
                      )),
                  MainInputWidget(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 150,
                    maxLines: 7,
                    focusNode: feedFocus,
                    controller: feedController,
                    isNullStr: !isFirst && feedController.text.isEmpty,
                    hint: 'Start Typing...',
                    labelWeight: FontWeight.w500,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 50),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        child: GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(0),
                            itemCount: pathOfPhotos.length + 1,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              childAspectRatio: 1 / 1,
                            ),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return GestureDetector(
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
                                                  'Please take feedback photos from',
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
                                                  pathOfPhotos.add(
                                                      await UtilProvider()
                                                          .getImage(false));

                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                () async {
                                                  pathOfPhotos.add(
                                                      await UtilProvider()
                                                          .getImage(true));

                                                  Navigator.pop(context);
                                                  setState(() {});
                                                }
                                              ]);
                                        },
                                      );
                                    },
                                    child: Image.asset(
                                        'assets/graphics/add_photo.png'));
                              }
                              return Padding(
                                  padding: EdgeInsets.all(5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: new Image(
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.fill,
                                        image: FileImage(
                                            File(pathOfPhotos[index - 1]))),
                                  ));
                            }),
                      )),
                  RoundButton(
                      label: 'Send Feedback',
                      color: AppColors.base,
                      action: () async {
                        FocusScope.of(context).unfocus();

                        if (feedController.text.isEmpty) {
                          setState(() {
                            isFirst = false;
                          });
                          return;
                        }
                        if (pathOfPhotos.isEmpty) {
                          UtilProvider()
                              .showToast(context, 'Add some pictures');
                          return;
                        }
                        List<String> photos = [];
                        for (var photo in pathOfPhotos) {
                          photos.add(
                              await UtilProvider().fileUpload(context, photo));
                        }

                        var params = {
                          "description": feedController.text,
                          "images": photos
                        };

                        final status =
                            await AuthProvider().addFeedback(context, params);
                        if (status) Navigator.pop(context);
                      })
                ],
              )),
        ));
  }
}
