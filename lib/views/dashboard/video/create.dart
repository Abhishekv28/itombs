import 'package:itombs/library.dart';
import 'package:itombs/providers/video.dart';

class VideoCreatePage extends StatefulWidget {
  final ItombModel itomb;
  VideoCreatePage({Key key, this.itomb});

  @override
  VideoCreatePageState createState() => new VideoCreatePageState();
}

class VideoCreatePageState extends State<VideoCreatePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  FocusNode titleFocus = FocusNode();
  FocusNode descFocus = FocusNode();
  bool isFirst = true;
  String pathOfVideo = '';

  static const double padding = 30, width = 250, gapOfDate = 20;
  final labelWeight = FontWeight.w600;
  bool isPublic = true;

  ItombProvider itombProvider;
  VideoProvider videoProvider;

  CachedVideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    itombProvider = Provider.of<ItombProvider>(context, listen: false);
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width - 20;
    final double imageHeight = imageWidth * 9 / 16;

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
              Expanded(
                  child: Text(
                'Add Video',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.base),
              )),
              MyTextButton(
                label: '',
                icon: null,
                fontWeight: FontWeight.normal,
                fontSize: 25,
                align: MainAxisAlignment.end,
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
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet<int>(
                          backgroundColor: Colors.transparent,
                          barrierColor:
                              AppColors.textHintColor.withOpacity(0.5),
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
                                    pathOfVideo = '';
                                    pathOfVideo = await UtilProvider()
                                        .getImage(false, isVideo: true);
                                    setState(() {});

                                    Navigator.pop(context);
                                  },
                                  () async {
                                    pathOfVideo = '';
                                    pathOfVideo = await UtilProvider()
                                        .getImage(true, isVideo: true);
                                    setState(() {});

                                    Navigator.pop(context);
                                  }
                                ]);
                          },
                        );
                      },
                      child: Container(
                          height: imageHeight,
                          width: imageWidth,
                          decoration: BoxDecoration(
                              color: Color(0xffE8E8E8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: pathOfVideo.isEmpty
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            'assets/graphics/video_upload.png'),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Choose a Video',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[500]),
                                        )
                                      ],
                                    )
                                  : VideoViewWidget(
                                      isFile: true, url: pathOfVideo)))),
                  const SizedBox(height: padding),
                  MainInputWidget(
                    width: double.infinity,
                    height: 50,
                    focusNode: titleFocus,
                    controller: titleController,
                    isNullStr: !isFirst && titleController.text.isEmpty,
                    label: 'Name',
                    iconColor: Colors.grey.withOpacity(0.5),
                    labelWeight: labelWeight,
                  ),
                  const SizedBox(height: padding),
                  MainInputWidget(
                    width: double.infinity,
                    height: 150,
                    maxLines: 5,
                    focusNode: descFocus,
                    controller: descController,
                    isNullStr: !isFirst && descController.text.isEmpty,
                    label: 'Description',
                    hint: 'Start Typing...',
                    labelWeight: labelWeight,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Make Video Public',
                          style: TextStyle(
                              color: AppColors.textColor, fontSize: 15),
                        ),
                        Switch(
                            value: isPublic,
                            onChanged: (value) {
                              setState(() {
                                isPublic = value;
                              });
                            },
                            activeTrackColor: AppColors.base,
                            activeColor: AppColors.darkBase,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey[350])
                      ]),
                  const SizedBox(height: 50),
                  RoundButton(
                    label: 'Add Video',
                    color: AppColors.base,
                    action: () async {
                      FocusScope.of(context).unfocus();

                      if (titleController.text.isEmpty ||
                          descController.text.isEmpty) {
                        setState(() {
                          isFirst = false;
                        });
                        return;
                      }
                      if (pathOfVideo.isEmpty) {
                        UtilProvider().showToast(context, 'Add a video');
                        return;
                      }

                      final pathOfthumbnail =
                          await VideoThumbnail.thumbnailFile(
                        video: pathOfVideo,
                        imageFormat: ImageFormat.PNG,
                        quality: 75,
                      );

                      print(pathOfthumbnail);
                      String video =
                          await UtilProvider().fileUpload(context, pathOfVideo);

                      String thumbnail = await UtilProvider()
                          .fileUpload(context, pathOfthumbnail);

                      var params = {
                        'target': 'itomb',
                        "target_id": widget.itomb.id,
                        "description": descController.text,
                        "video": video,
                        'thumbnail': thumbnail,
                        "title": titleController.text,
                        // "isPublic": isPublic
                      };
                      bool status = await videoProvider.add(context, params);
                      if (status) Navigator.pop(context);
                    },
                  ),
                ],
              )),
        ));
  }
}
