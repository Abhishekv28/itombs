import 'package:itombs/library.dart';

class VideosPage extends StatefulWidget {
  final ItombModel itomb;
  VideosPage({Key key, this.itomb});

  @override
  VideosPageState createState() => new VideosPageState();
}

class VideosPageState extends State<VideosPage> with AfterLayoutMixin {
  TextEditingController contentController = TextEditingController();
  FocusNode contentFocus = FocusNode();
  bool isFirst = true;
  List<String> pathOfPhotos = [];

  static const double padding = 30, width = 250, gapOfDate = 20;
  final labelWeight = FontWeight.w600;
  bool isShowForGroup = true;

  ItombProvider itombProvider;
  VideoProvider videoProvider;

  @override
  void initState() {
    super.initState();
    itombProvider = Provider.of<ItombProvider>(context, listen: false);
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
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
                action: () {
                  videoProvider.clear();
                  Navigator.pop(context);
                },
              ),
              Expanded(
                  child: Text(
                'My Videos',
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
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: RoundButton(
                label: 'Add Video',
                icon: Icons.video_call_rounded,
                iconSize: 25,
                width: MediaQuery.of(context).size.width - 20,
                height: 45,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: AppColors.base,
                action: () async {
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: const Duration(
                              milliseconds: AppConstants.timeOfPagination),
                          type: AppConstants.typeOfPagination,
                          child: VideoCreatePage(itomb: widget.itomb)));
                },
              )),
          Expanded(child: Consumer<VideoProvider>(builder:
              (BuildContext context, VideoProvider provider, Widget child) {
            if (provider.isLoading)
              return Center(
                  child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ));

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: provider.videos.length,
              itemBuilder: (BuildContext context, int index) {
                return VideoWidget(
                    user: AuthProvider.user, video: provider.videos[index]);
              },
            );
          }))
        ]));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final param = {'target': 'itomb', 'target_id': widget.itomb.id};
    videoProvider.load(context, param);
  }
}
