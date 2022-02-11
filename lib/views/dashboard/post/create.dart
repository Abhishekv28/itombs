import 'dart:io';

import 'package:itombs/library.dart';

class PostCreatePage extends StatefulWidget {
  final ItombModel itomb;
  PostCreatePage({Key key, this.itomb});

  @override
  PostCreatePageState createState() => new PostCreatePageState();
}

class PostCreatePageState extends State<PostCreatePage> {
  TextEditingController contentController = TextEditingController();
  FocusNode contentFocus = FocusNode();
  bool isFirst = true;
  List<String> pathOfPhotos = [];

  static const double padding = 30, width = 250, gapOfDate = 20;
  final labelWeight = FontWeight.w600;
  bool isShowForGroup = true;

  ItombProvider itombProvider;
  PostProvider postProvider;

  @override
  void initState() {
    super.initState();
    itombProvider = Provider.of<ItombProvider>(context, listen: false);
    postProvider = Provider.of<PostProvider>(context, listen: false);
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
                label: 'Cancel',
                fontWeight: FontWeight.normal,
                action: () => Navigator.pop(context),
              ),
              Expanded(child: Container()),
              RoundButton(
                width: 75,
                height: 30,
                label: 'Post',
                padding: EdgeInsets.zero,
                fontWeight: FontWeight.normal,
                color: AppColors.base,
                action: () async {
                  FocusScope.of(context).unfocus();

                  if (contentController.text.isEmpty) {
                    setState(() {
                      isFirst = false;
                    });
                    return;
                  }
                  if (pathOfPhotos.isEmpty) {
                    UtilProvider().showToast(context, 'Add some pictures');
                    return;
                  }
                  List<String> photos = [];
                  for (var photo in pathOfPhotos) {
                    photos.add(await UtilProvider().fileUpload(context, photo));
                  }

                  var params = {
                    "itomb": widget.itomb.id,
                    "content": contentController.text,
                    "photo": photos
                  };
                  bool status = await postProvider.add(context, params);
                  if (status) Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: max(MediaQuery.of(context).size.height, 900.0),
              padding: const EdgeInsets.only(
                  top: 30, left: 20, right: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MainInputWidget(
                    width: double.infinity,
                    height: 150,
                    maxLines: 7,
                    focusNode: contentFocus,
                    controller: contentController,
                    isNullStr: !isFirst && contentController.text.isEmpty,
                    hint: 'Start Typing...',
                    labelWeight: labelWeight,
                  ),
                  const SizedBox(height: 50),
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        itemCount: pathOfPhotos.length + 1,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                          title: 'Please take card photo from',
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
                  ),
                  const SizedBox(height: padding),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Show to Only Group Members',
                          style: TextStyle(
                              color: AppColors.textColor, fontSize: 15),
                        ),
                        Switch(
                            value: isShowForGroup,
                            onChanged: (value) {
                              setState(() {
                                isShowForGroup = value;
                              });
                            },
                            activeTrackColor: AppColors.base,
                            activeColor: AppColors.darkBase,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey[350])
                      ])
                ],
              )),
        ));
  }
}
