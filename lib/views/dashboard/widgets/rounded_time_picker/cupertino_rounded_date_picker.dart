import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itombs/library.dart';

import 'era_mode.dart';
import 'flutter_cupertino_rounded_date_picker_widget.dart';

class CupertinoRoundedDatePicker {
  static show(BuildContext context,
      {Locale locale,
      DateTime initialDate,
      DateTime minimumDate,
      DateTime maximumDate,
      int minimumYear,
      String title,
      int maximumYear,
      Function(DateTime) onDateTimeChanged,
      int minuteInterval = 1,
      bool use24hFormat = false,
      CupertinoDatePickerMode initialDatePickerMode =
          CupertinoDatePickerMode.date,
      EraMode era = EraMode.CHRIST_YEAR,
      double borderRadius = 16,
      String fontFamily,
      Color background = Colors.white,
      Color textColor = Colors.black54,
      Function doneAction,
      Function cancelAction}) async {
    initialDate ??= DateTime.now();
    minimumDate ??= DateTime.now().subtract(Duration(days: 7));
    maximumDate ??= DateTime.now().add(Duration(days: 7));
    minimumYear ??= DateTime.now().year - 1;
    maximumYear ??= DateTime.now().year + 1;

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Stack(
            // height: 600,
            // color: Colors.red,

            alignment: Alignment.topCenter,
            children: <Widget>[
              FlutterRoundedCupertinoDatePickerWidget(
                use24hFormat: use24hFormat,
                onDateTimeChanged: (dateTime) {
                  if (onDateTimeChanged != null) {
                    onDateTimeChanged(dateTime);
                  }
                },
                era: era,
                background: background,
                textColor: textColor,
                borderRadius: borderRadius,
                fontFamily: fontFamily,
                initialDateTime: initialDate,
                mode: initialDatePickerMode,
                minuteInterval: minuteInterval,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                maximumYear: maximumYear,
                minimumYear: minimumYear,
              ),
              SheetTopHandleWidget(),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 0, right: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          cancelAction();
                          Navigator.pop(context);
                        },
                        child: Text('Cancel',
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 17))),
                    FlatButton(
                        onPressed: () {
                          doneAction();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Done',
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 17),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, left: 0, right: 0),
                child: Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.textColor)),
              )
            ]);
      },
    );
  }
}
