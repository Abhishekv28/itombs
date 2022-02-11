import 'package:itombs/library.dart';

class MyTextButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final double fontSize;
  final double iconSize;
  final FontWeight fontWeight;
  final Color color;
  final Color iconColor;
  final MainAxisAlignment align;
  final Function action;

  MyTextButton(
      {Key key,
      this.label,
      this.icon,
      this.fontSize = 17,
      this.iconSize,
      this.color = AppColors.base,
      this.iconColor,
      this.fontWeight = FontWeight.bold,
      this.align = MainAxisAlignment.end,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero, minimumSize: Size(50, 30)),
        child: Row(mainAxisAlignment: align, children: [
          if (icon != null)
            Icon(icon, size: iconSize ?? fontSize, color: iconColor ?? color),
          if (label != null)
            Text(
              label,
              style: TextStyle(
                  fontSize: fontSize, color: color, fontWeight: fontWeight),
            )
        ]),
        onPressed: action);
  }
}
