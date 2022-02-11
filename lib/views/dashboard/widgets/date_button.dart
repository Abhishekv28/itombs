import 'package:flutter/cupertino.dart';
import 'package:itombs/library.dart';

class DateButtonWidget extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final String label;
  final String titleOfDatePicker;
  final double fontSize, iconSize;
  final Color colorLabel;
  final DateTime currentDate;
  final Function(DateTime) action;

  DateButtonWidget(
      {Key key,
      this.width,
      this.height,
      this.label,
      this.titleOfDatePicker = '',
      this.radius = 8,
      this.fontSize = 15,
      this.iconSize = 20,
      this.colorLabel = Colors.grey,
      this.currentDate,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
        height: height,
        width: width,
        radius: radius,
        blurRadius: 5,
        child: TextButton(
            onPressed: () {
              final maxDate = DateTime.now();
              DateTime postDate =
                  (currentDate == null) ? DateTime.now() : currentDate;

              CupertinoRoundedDatePicker.show(context,
                  fontFamily: "Mali",
                  textColor: AppColors.textColor,
                  borderRadius: 16,
                  use24hFormat: true,
                  minimumDate: DateTime(1950),
                  maximumDate: maxDate,
                  minimumYear: 1930,
                  initialDate: postDate,
                  title: titleOfDatePicker,
                  initialDatePickerMode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (newDateTime) {
                postDate = newDateTime;
              }, doneAction: () {
                action(postDate);
              }, cancelAction: () {});
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: fontSize, color: colorLabel),
                ),
                Icon(Icons.expand_more, color: Colors.grey),
              ],
            )));
  }
}
