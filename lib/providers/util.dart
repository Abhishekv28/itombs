import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:itombs/library.dart';

class UtilProvider extends ChangeNotifier {
  static String userToken = '';
  static GraphQLClient gqClient;
  static int selectedPageIndex = 0;

  bool isEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(email);
  }

  void setPageIndex(int index) {
    selectedPageIndex = index;
    notifyListeners();
  }

  Future<QueryResult> gqRequest(
      String query, Map<String, dynamic> params) async {
    if (gqClient == null) initClient();

    final QueryOptions options = QueryOptions(
      documentNode: gql(query),
      variables: params,
    );

    final QueryResult result = await gqClient.query(options);
    return result;
  }

  void initClient() {
    final AuthLink authLink = AuthLink(
      getToken: () => 'Bearer ${UtilProvider.userToken}',
    );
    final WebSocketLink websocketLink = WebSocketLink(
      url: 'ws://167.172.150.160:4000/graphql',
      config: SocketClientConfig(
          autoReconnect: true,
          inactivityTimeout: Duration(seconds: 30),
          initPayload: () async {
            return {'Authorization': 'Bearer ${UtilProvider.userToken}'};
          }),
    );
    gqClient = GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: authLink
          .concat(
            HttpLink(
              uri: Strings.baseQueryURL,
            ),
          )
          .concat(websocketLink),
    );
  }

  void showToast(BuildContext context, String message) {
    Toast.show(
      message,
      context,
      duration: Toast.LENGTH_SHORT,
      gravity: Toast.BOTTOM,
      backgroundColor: const Color(0xFF1B130F),
      textColor: Colors.white,
    );
  }

  void showProgressing(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
              child: SpinKitFadingCube(
            size: 50,
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.green : Colors.white,
                ),
              );
            },
          ) //CircularProgressIndicator(),
              );
        });
  }

  Future<String> getImage(bool isCamera, {bool isVideo = false}) async {
    PickedFile pickedFile;

    if (isVideo) {
      if (isCamera) {
        pickedFile = await ImagePicker().getVideo(source: ImageSource.camera);
        if (pickedFile != null) {
          return pickedFile.path;
        }
      } else {
        FilePickerResult result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['mp4', 'mov'],
        );
        if (result != null) {
          return result.paths.first;
        }
      }
    } else {
      pickedFile = await ImagePicker().getImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);
      if (pickedFile != null) {
        return pickedFile.path;
      }
    }

    return '';
  }

  Future<String> fileUpload(BuildContext context, String filePath) async {
    UtilProvider().showProgressing(context);

    final client = GraphQLClient(
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
        link: HttpLink(
          uri: Strings.baseQueryURL,
        ));

    var options = MutationOptions(
      documentNode: gql(Queries.fileUpload),
      variables: {
        "file": File(filePath),
      },
    );

    final QueryResult result = await client.mutate(options);
    Navigator.pop(context);
    if (result.data != null && result.data['uploadAsset'] != null) {
      return result.data['uploadAsset']['id'];
    } else {
      UtilProvider().showToast(context, 'Failed to upload file');
      return '';
    }
  }

  String getTimeString(String time, {bool isShowHour = true}) {
    DateTime date = DateTime.parse(time).toLocal();
    final now = new DateTime.now();

    if (now.year == date.year)
      return isShowHour
          ? DateFormat('HH:mm, dd MMM').format(date)
          : DateFormat('dd MMM').format(date);
    return DateFormat('dd MMM, yyyy').format(date);
  }

  bool isMe(BuildContext context, String userID) {
    return AuthProvider.user.id == userID;
  }

  Future<bool> showAlertDialog(
      {BuildContext context,
      String title,
      String content,
      String cancelActionText,
      String defaultActionText,
      Function defaultAction}) async {
    if (!Platform.isIOS) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            if (cancelActionText != null)
              FlatButton(
                child: Text(cancelActionText),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            FlatButton(
                child: Text(defaultActionText,
                    style: TextStyle(color: Colors.red)),
                onPressed: () {
                  defaultAction();
                  Navigator.of(context).pop(true);
                }),
          ],
        ),
      );
    }

    // todo : showDialog for ios
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (cancelActionText != null)
            CupertinoDialogAction(
              child: Text(cancelActionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          CupertinoDialogAction(
              child:
                  Text(defaultActionText, style: TextStyle(color: Colors.red)),
              onPressed: () {
                defaultAction();
                Navigator.of(context).pop(true);
              }),
        ],
      ),
    );
  }
}

mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then(
      (_) => afterFirstLayout(context),
    );
  }

  void afterFirstLayout(BuildContext context);
}
