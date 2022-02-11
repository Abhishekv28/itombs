import 'package:itombs/library.dart';

class RoundButton extends StatelessWidget {
  final String label;
  final double width, height;
  final IconData icon;
  final bool isFill;
  final Color color;
  final double fontSize;
  final double iconSize;
  final double borderWidth;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final Function action;

  RoundButton(
      {Key key,
      this.label,
      this.icon,
      this.width = 250,
      this.height = 50,
      this.color = AppColors.darkBase,
      this.isFill = true,
      this.padding,
      this.fontSize = 17,
      this.iconSize = 17,
      this.borderWidth = 2,
      this.fontWeight = FontWeight.bold,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: action,
        padding: padding,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: isFill ? color : Colors.white,
              border: Border.all(
                  color: isFill ? Colors.transparent : color,
                  width: borderWidth),
              borderRadius: BorderRadius.all(
                Radius.circular(height / 2),
              )),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (icon != null)
              Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(icon,
                      color: isFill ? Colors.white : color,
                      size: iconSize == null ? fontSize : iconSize)),
            Text(label,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: isFill ? Colors.white : color))
          ]),
        ));
  }
}
