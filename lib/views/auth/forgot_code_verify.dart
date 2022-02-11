import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:itombs/library.dart';

class ForgotCodeVerifyPage extends StatefulWidget {
  final String code;
  final String email;
  ForgotCodeVerifyPage({Key key, this.code, this.email});

  @override
  ForgotCodeVerifyPageState createState() => new ForgotCodeVerifyPageState();
}

class ForgotCodeVerifyPageState extends State<ForgotCodeVerifyPage> {
  TextEditingController code1Controller = TextEditingController();
  TextEditingController code2Controller = TextEditingController();
  TextEditingController code3Controller = TextEditingController();
  TextEditingController code4Controller = TextEditingController();
  FocusNode code1Focus = FocusNode();
  FocusNode code2Focus = FocusNode();
  FocusNode code3Focus = FocusNode();
  FocusNode code4Focus = FocusNode();
  bool isFirst = true;

  static const double padding = 80, width = 250;

  @override
  void initState() {
    super.initState();
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
                action: () => Navigator.pop(context),
              ),
              // Your widgets here
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: max(MediaQuery.of(context).size.height, 900.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 300,
                      height: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/graphics/logo.png', height: 85),
                            const SizedBox(width: 20),
                            Expanded(
                                child: Text(
                              'Verify Code',
                              maxLines: 2,
                              style: TextStyle(
                                  color: AppColors.darkBase,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 35),
                            )),
                          ])),
                  Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 30),
                      child: ShadowBox(
                        height: 300,
                        width: 350,
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    codeItem(0),
                                    codeItem(1),
                                    codeItem(2),
                                    codeItem(3)
                                  ],
                                ),
                                const SizedBox(height: padding),
                                RoundButton(
                                  label: 'Verify',
                                  color: AppColors.base,
                                  action: () async {
                                    final code1 = code1Controller.text;
                                    final code2 = code2Controller.text;
                                    final code3 = code3Controller.text;
                                    final code4 = code4Controller.text;
                                    if (code1.isEmpty ||
                                        code2.isEmpty ||
                                        code3.isEmpty ||
                                        code4.isEmpty) {
                                      setState(() {
                                        isFirst = false;
                                      });
                                      return;
                                    }

                                    final codeInput =
                                        '$code1$code2$code3$code4';
                                    if (widget.code != codeInput) {
                                      UtilProvider()
                                          .showToast(context, 'Invalid Code');
                                    } else {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              duration: const Duration(
                                                  milliseconds: AppConstants
                                                      .timeOfPagination),
                                              type:
                                                  AppConstants.typeOfPagination,
                                              child: NewPwdPage(
                                                  code: widget.code,
                                                  email: widget.email)));
                                    }
                                  },
                                ),
                              ],
                            )),
                      )),
                ],
              )),
        ));
  }

  Widget codeItem(int index) {
    List<TextEditingController> controllers = [
      code1Controller,
      code2Controller,
      code3Controller,
      code4Controller
    ];
    List<FocusNode> focusNodes = [
      code1Focus,
      code2Focus,
      code3Focus,
      code4Focus
    ];
    return SizedBox(
      width: 50,
      child: Column(
        children: [
          TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            enabled: true,
            autofocus: index == 0,
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index != 3) {
                  FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                }
              } else {
                if (index != 0) {
                  FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                }
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.allow(RegExp("[0-9]"))
            ],
            style: TextStyle(fontSize: 25),
            decoration: InputDecoration(border: InputBorder.none),
          ),
          Container(
            width: 40,
            height: 2,
            color: AppColors.base,
          )
        ],
      ),
    );
  }
}
