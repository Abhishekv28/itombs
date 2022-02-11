import 'package:itombs/library.dart';

class FillCircle extends StatelessWidget {
  final double size;
  final bool isSelected;
  final Color colorSelected, colorUnselected;

  FillCircle(
      {Key key,
      this.size = 10,
      this.isSelected = true,
      this.colorSelected = AppColors.base,
      this.colorUnselected = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: isSelected ? colorSelected : colorUnselected,
            borderRadius: BorderRadius.all(
              Radius.circular(size / 2),
            )));
  }
}
