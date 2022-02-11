import 'package:itombs/library.dart';

class ShadowBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final double blurRadius;
  final double depth;
  final Color colorLight, colorDark;
  final Widget child;

  ShadowBox(
      {Key key,
      this.width,
      this.height,
      this.radius = 12,
      this.blurRadius = 10,
      this.depth = 3,
      this.colorLight = const Color(0xffe9e9e9),
      this.colorDark = const Color(0xffe9e9e9),
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: blurRadius,
                color: colorDark,
                offset: Offset(
                  depth,
                  depth,
                ),
              ),
              BoxShadow(
                blurRadius: blurRadius,
                color: colorLight,
                offset: Offset(
                  -depth,
                  -depth,
                ),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(
              radius,
            ))),
        child: child);
  }
}
