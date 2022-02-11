import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:itombs/library.dart';

class VideoViewWidget extends StatefulWidget {
  final bool isFile;
  final String url;
  VideoViewWidget({Key key, this.isFile = false, this.url}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new VideoViewWidgetState();
}

class VideoViewWidgetState extends State<VideoViewWidget> {
  CachedVideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    if (widget.isFile) {
      videoController = CachedVideoPlayerController.file(File(widget.url));
    } else {
      videoController = CachedVideoPlayerController.network(widget.url);
    }
    videoController
      ..initialize().then((_) {
        setState(() {
          videoController.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return videoController.value.initialized
        ? AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: CachedVideoPlayer(videoController),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                  height: 40, width: 40, child: CircularProgressIndicator()),
            ),
          );
  }
}
