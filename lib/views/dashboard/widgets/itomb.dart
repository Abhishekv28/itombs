import 'package:itombs/library.dart';

class ItombWidget extends StatelessWidget {
  final bool isMini;
  final ItombModel itomb;
  ItombWidget({Key key, this.itomb, this.isMini}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int noti = Random().nextInt(10);
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      duration: const Duration(
                          milliseconds: AppConstants.timeOfPagination),
                      type: AppConstants.typeOfPagination,
                      child: ItombProfilePage(itomb: itomb, isMini: isMini)));
            },
            child: ShadowBox(
                height: 150,
                width: double.infinity,
                child: Row(children: [
                  const SizedBox(width: 10),
                  CacheImageWidget(
                      size: 120, url: itomb.photo, radius: 8, padding: 40),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Row(children: [
                          Expanded(
                              child: Text(
                            itomb.name,
                            style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          )),
                          if (noti > 3)
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      color: AppColors.base,
                                      child: Center(
                                        child: Text(
                                          noti.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    )))
                        ]),
                        Padding(
                            padding: const EdgeInsets.only(top: 7, bottom: 7),
                            child: Text(
                              '${UtilProvider().getTimeString(itomb.dateOfBirth)} - ${UtilProvider().getTimeString(itomb.dateOfPass)}',
                              style: TextStyle(
                                  color: AppColors.textHintColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                            )),
                        Text(
                          itomb.bio,
                          maxLines: 4,
                          style: TextStyle(
                              color: AppColors.textHintColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        )
                      ]))
                ]))));
  }
}
