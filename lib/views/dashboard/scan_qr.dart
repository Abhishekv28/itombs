import 'package:flutter/services.dart';
import 'package:itombs/library.dart';

class ScanQRPage extends StatefulWidget {
  ScanQRPage({Key key}) : super(key: key);

  @override
  ScanQRPageState createState() {
    return ScanQRPageState();
  }
}

class ScanQRPageState extends State<ScanQRPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    scanQR();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> scanQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'OK',
        true,
        ScanMode.QR,
      ).then((value) async {
        if (value.isEmpty) {
          UtilProvider().showToast(context, 'Error to scan QR code');
          Navigator.pop(context);
          return;
        }
      });
    } on PlatformException {}
  }
}
