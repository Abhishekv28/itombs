import 'package:itombs/library.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;

  PostWidget({Key key, this.post}) : super(key: key);
  @override
  PostWidgetState createState() => new PostWidgetState();
}

class PostWidgetState extends State<PostWidget> {
  PostProvider postProvider;
  bool isLiked;
  int numOfLike;

  @override
  void initState() {
    super.initState();
    postProvider = Provider.of<PostProvider>(context, listen: false);
    isLiked = widget.post.isLiked;
    numOfLike = widget.post.numOfLikes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GestureDetector(
            onTap: () {},
            child: ShadowBox(
                radius: 6,
                blurRadius: 5,
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 7, right: 7),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            CacheImageWidget(
                                size: 45,
                                url: widget.post.user.photo,
                                radius: 6,
                                padding: 15),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  Text(
                                    widget.post.user.name,
                                    style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // Padding(
                                  //     padding: const EdgeInsets.only(top: 5),
                                  //     child: Text(
                                  //       '${UtilProvider().getTimeString(widget.post.itomb.dateOfBirth)} - ${UtilProvider().getTimeString(widget.post.itomb.dateOfPass)}',
                                  //       style: TextStyle(
                                  //           color: AppColors.textHintColor,
                                  //           fontSize: 12,
                                  //           fontWeight: FontWeight.w300),
                                  //     )),
                                ])),
                            MyTextButton(
                                icon: Icons.more_vert,
                                fontSize: 25,
                                color: Colors.black54,
                                action: () {}),
                          ]),
                          const SizedBox(height: 10),
                          Text(
                            widget.post.content,
                            style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 10),
                          Container(
                              height:
                                  (MediaQuery.of(context).size.width - 50) / 3,
                              child: StaggeredGridView.countBuilder(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  padding: const EdgeInsets.all(0),
                                  mainAxisSpacing: 0,
                                  itemCount: widget.post.photos.length < 3
                                      ? widget.post.photos.length
                                      : 3,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  duration: const Duration(
                                                      milliseconds: AppConstants
                                                          .timeOfPagination),
                                                  type: AppConstants
                                                      .typeOfPagination,
                                                  child: FullPhotoScreen(
                                                    photos: widget.post.photos,
                                                    index: index,
                                                  )));
                                        },
                                        child: (index < 2)
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: CacheImageWidget(
                                                    size: 50,
                                                    url: widget.post.photos[
                                                        index])) //widget.post.photo.first),
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Stack(
                                                  children: [
                                                    CacheImageWidget(
                                                        size: double.infinity,
                                                        url: widget
                                                            .post.photos[2]),
                                                    if (widget.post.photos
                                                            .length >
                                                        3)
                                                      Container(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        child: Center(
                                                          child: Text(
                                                            '+${widget.post.photos.length - 3}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 27,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                )));
                                  },
                                  staggeredTileBuilder: (index) {
                                    return StaggeredTile.count(1, 1);
                                  })),
                          Padding(
                              padding: const EdgeInsets.only(top: 5, right: 10),
                              child: Row(children: [
                                Expanded(child: Container()),
                                TextButton(
                                    onPressed: () {
                                      postProvider.like(
                                          context, widget.post.id);
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                        ])))));
  }
}
