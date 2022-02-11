import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:itombs/library.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HttpLink httpLink = HttpLink(
      uri:Strings.baseQueryURL,
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject), link: httpLink),
    );

    return GraphQLProvider(
        client: client,
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (BuildContext context) => UtilProvider()),
              ChangeNotifierProvider(
                  create: (BuildContext context) => AuthProvider()),
              ChangeNotifierProvider(
                  create: (BuildContext context) => ItombProvider()),
              ChangeNotifierProvider(
                  create: (BuildContext context) => PostProvider()),
              ChangeNotifierProvider(
                  create: (BuildContext context) => MemberProvider()),
              ChangeNotifierProvider(
                  create: (BuildContext context) => VideoProvider()),
              ChangeNotifierProvider(
                  create: (BuildContext context) => ChatProvider()),
              ChangeNotifierProvider(
                  create: (BuildContext context) => MessageProvider()),
            ],
            child: MaterialApp(
              title: 'iTombs',
              theme: ThemeData(primaryColor: Colors.white),
              debugShowCheckedModeBanner: false,
              routes: <String, WidgetBuilder>{
                Strings.route_login: (_) => new LoginPage()
              },
              home: SplashPage(),
            )));
  }
}
