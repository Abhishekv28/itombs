import 'package:itombs/library.dart';

class MembersPage extends StatefulWidget {
  final ItombModel itomb;
  MembersPage({Key key, this.itomb});

  @override
  MembersPageState createState() => new MembersPageState();
}

class MembersPageState extends State<MembersPage> with AfterLayoutMixin {
  MemberProvider memberProvider;
  @override
  void initState() {
    super.initState();
    memberProvider = Provider.of<MemberProvider>(context, listen: false);
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
                    memberProvider.clear();
                    Navigator.pop(context);
                  }),
              Expanded(
                  child: Text(
                'Group Members',
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
                label: 'Add Group Members',
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
                          child: MemberAddPage(
                            itomb: widget.itomb,
                          ))).then((value) {
                    setState(() {});
                  });
                },
              )),
          Expanded(child: Consumer<MemberProvider>(builder:
              (BuildContext context, MemberProvider provider, Widget child) {
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
              itemCount: provider.addedUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return MemberWidget(
                  itomb: widget.itomb,
                  user: provider.addedUsers[index],
                  isForAdd: false,
                );
              },
            );
          }))
        ]));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    memberProvider.load(context, itombID: widget.itomb.id);
  }
}
