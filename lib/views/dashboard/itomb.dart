import 'package:itombs/library.dart';

class ItombPage extends StatefulWidget {
  ItombPage({Key key});

  @override
  ItombPageState createState() => new ItombPageState();
}

class ItombPageState extends State<ItombPage> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  ItombProvider itombProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<ItombProvider>(builder:
        (BuildContext context, ItombProvider itombProvider, Widget child) {
      return itombProvider.isLoading
          ? Center(
              child: SizedBox(
                  height: 50, width: 50, child: CircularProgressIndicator()))
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: (UtilProvider.selectedPageIndex == 1
                          ? itombProvider.myItombs
                          : itombProvider.allItombs)
                      .length +
                  (UtilProvider.selectedPageIndex == 1 ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                List<ItombModel> itombs = UtilProvider.selectedPageIndex == 1
                    ? itombProvider.myItombs
                    : itombProvider.allItombs;
                if (index < itombs.length) {
                  ItombModel itomb = itombs[index];
                  return ItombWidget(itomb: itomb, isMini: false);
                }
                return Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: RoundButton(
                      label: 'Create a New iTomb',
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
                                    milliseconds:
                                        AppConstants.timeOfPagination),
                                type: AppConstants.typeOfPagination,
                                child: ItombCreatePage()));
                      },
                    ));
              },
            );
    });
  }
}
