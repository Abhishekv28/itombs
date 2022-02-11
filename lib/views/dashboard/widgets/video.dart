import 'package:flutter/cupertino.dart';
import 'package:itombs/library.dart';

class VideoWidget extends StatefulWidget {
  final VideoModel video;
  final UserModel user;
  VideoWidget({Key key, this.video, this.user}) : super(key: key);
  VideoWidgetState createState() => new VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  VideoProvider videoProvider;
  bool isLiked;
  int numOfLike;
  @override
  void initState() {
    super.initState();

    videoProvider = Provider.of<VideoProvider>(context, listen: false);
    isLiked = widget.video.isLiked;
    numOfLike = widget.video.numOfLikes;
  }

  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width - 20;
    final double imageHeight = imageWidth * 9 / 16;
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Color(0xffe9e9e9),
                    offset: Offset(
                      3,
                      3,
                    ),
                  ),
                  BoxShadow(
                    blurRadius: 10,
                    color: Color(0xffe9e9e9),
                    offset: Offset(
                      -3,
                      -3,
                    ),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(
                  10,
                ))),
            child: Column(children: [
              Consumer<VideoProvider>(builder:
                  (BuildContext context, VideoProvider provider, Widget child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    provider.selectedVideo == widget.video
                        ? VideoViewWidget(isFile: false, url: widget.video.url)
                        : CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                              width: 70,
                              height: 70,
                              padding: EdgeInsets.all(20),
                            ),
                            useOldImageOnUrlChange: true,
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'assets/graphics/img_not_available.jpeg',
                                width: imageWidth,
                                height: imageHeight,
                                fit: BoxFit.cover,
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: widget.video.thumbnail,
                            width: imageWidth,
                            height: imageHeight,
                            fit: BoxFit.cover,
                          ),
                    if (provider.selectedVideo != widget.video)
                      IconButton(
                          icon: Icon(
                            Icons.play_arrow_rounded,
                            size: 60,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            provider.selectedVideo = widget.video;
                            provider.notifyListeners();
                          })
                  ],
                );
              }),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5, right: 5, left: 5, bottom: 10),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.lock, color: AppColors.base, size: 17),
                              Text(
                                ' ${widget.video.title}',
                                style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          // Text(
                          //   '12/14/2020',
                          //   style: TextStyle(
                          //       color: AppColors.textColor,
                          //       fontSize: 13,
                          //       fontWeight: FontWeight.w400),
                          // )
                        ]),
                    Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.video.description,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                            ))),
                    Padding(
                        padding: const EdgeInsets.only(top: 5, right: 10),
                        child: Row(children: [
                          Expanded(child: Container()),
                          TextButton(
                              onPressed: () {
                                videoProvider.like(context, widget.video.id);
                                setState(() {
                                  isLiked = !isLiked;
                                  if (isLiked) {
                                    numOfLike++;
                                  } else {
                                    numOfLike--;
                                  }
                                });
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(60, 10)),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '$numOfLike Likes',
                                      style: TextStyle(
                                          color: AppColors.textColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(
                                      isLiked
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.heart,
                                      color: isLiked
                                          ? Colors.red
                                          : AppColors.textColor,
                                      size: 15,
                                    )
                                  ]))
                        ]))
                  ],
                ),
              ),
            ])));
  }
}
