import 'package:flutter/services.dart';
import 'package:itombs/library.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum WebviewTag { policy, terms, about }

class PrivacyPolicyPage extends StatefulWidget {
  final WebviewTag target;
  PrivacyPolicyPage({Key key, this.target}) : super(key: key);

  @override
  PrivacyPolicyPageState createState() => new PrivacyPolicyPageState();
}

class PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  WebViewController controller;

  String title, filePath;

  @override
  Widget build(BuildContext context) {
    switch (widget.target) {
      case WebviewTag.policy:
        title = 'Privacy Policy';
        filePath = 'assets/htmls/policy.html';
        break;
      case WebviewTag.about:
        title = 'About Us';
        filePath = 'assets/htmls/about.html';
        break;
      default:
        title = 'Terms of Service';
        filePath = 'assets/htmls/terms.html';
        break;
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MyTextButton(
              label: 'Back',
              icon: Icons.arrow_back_ios,
              fontWeight: FontWeight.normal,
              align: MainAxisAlignment.start,
              action: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
                child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.base),
            )),
            MyTextButton(
              label: '',
              icon: null,
              fontWeight: FontWeight.normal,
              fontSize: 25,
              align: MainAxisAlignment.end,
              action: () {},
            )
          ],
        ),
      ),
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
          loadHtml();
        },
      ),
    );
  }

  loadHtml() async {
    String fileText = await rootBundle.loadString(filePath);
    controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
