import 'package:itombs/library.dart';

class MemberAddPage extends StatefulWidget {
  final ItombModel itomb;
  MemberAddPage({Key key, this.itomb});

  @override
  MemberAddPageState createState() => new MemberAddPageState();
}

class MemberAddPageState extends State<MemberAddPage> with AfterLayoutMixin {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
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
                    memberProvider.allUsers.clear();
                    Navigator.pop(context);
                  }),
              Expanded(
                  child: Text(
                'Add Member',
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
        body: Column(
          children: [
            Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 20,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Color(0x20767680),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TextFormField(
                  controller: searchController,
                  focusNode: searchFocus,
                  enabled: true,
                  onChanged: (val) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 23, maxHeight: 20),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.search,
                        size: 25,
                        color: AppColors.base.withOpacity(0.5),
                      ),
                    ),
                    hintText: 'search...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
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

              List<UserModel> users = provider.allUsers
                  .where((element) => element.name
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()))
                  .toList();

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10),
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return MemberWidget(
                    itomb: widget.itomb,
                      user: users[index],
                      isForAdd: true,
                     );
                },
              );
            }))
          ],
        ));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    memberProvider.load(context);
  }
}
