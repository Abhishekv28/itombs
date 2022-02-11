import 'package:itombs/library.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ItombProvider itombProvider =
        Provider.of<ItombProvider>(context, listen: false);
    UtilProvider utilProvider =
        Provider.of<UtilProvider>(context, listen: false);

    List<DrawerList> drawerList = [
      DrawerList(
          labelName: 'Home',
          icon: 'assets/graphics/menu_home.png',
          action: () {
            Navigator.pop(context);
            utilProvider.setPageIndex(0);
            if (itombProvider.allItombs.isEmpty) {
              itombProvider.load(context);
            }
          }),
      DrawerList(
          labelName: 'My iTombs',
          icon: 'assets/graphics/menu_itombs.png',
          action: () {
            Navigator.pop(context);
            utilProvider.setPageIndex(1);
            if (itombProvider.myItombs.isEmpty) {
              itombProvider.load(context);
            }
          }),
      DrawerList(
          labelName: 'Messages',
          icon: 'assets/graphics/menu_messages.png',
          action: () {
            Navigator.pop(context);
            utilProvider.setPageIndex(2);
          }),
      DrawerList(
          labelName: 'QR Scanner',
          icon: 'assets/graphics/menu_qr.png',
          action: () {
            Navigator.pop(context);
            utilProvider.setPageIndex(3);
          }),
      DrawerList(
          labelName: 'Settings',
          icon: 'assets/graphics/menu_setting.png',
          action: () async {
            Navigator.pop(context);
            utilProvider.setPageIndex(4);
          }),
      DrawerList(
          labelName: 'Log Out',
          icon: 'assets/graphics/menu_logout.png',
          action: () async {
            await AuthProvider().logOut(context);
          })
    ];
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      color: AppColors.darkBase,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: CacheImageWidget(
                        size: 60,
                        url: AuthProvider.user.photo,
                        radius: 6,
                        padding: 15,
                        isProfile: true)),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AuthProvider.user.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      AuthProvider.user.email,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Divider(
            thickness: 1.5,
            height: 1,
            color: Colors.white,
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(context, drawerList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget inkwell(BuildContext context, DrawerList listData) {
    return TextButton(
        onPressed: listData.action,
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 25, bottom: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 20),
                      child: Image(
                          image: AssetImage(listData.icon),
                          width: 25,
                          color: Colors.white),
                    ),
                    Text(
                      listData.labelName,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ],
                )),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.white.withOpacity(0.2),
            )
          ],
        ));
  }
}

class DrawerList {
  DrawerList(
      {this.labelName = '', this.icon, this.imageName = '', this.action});

  String labelName;
  String icon;
  String imageName;
  Function action;
}
