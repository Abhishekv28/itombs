import 'package:itombs/library.dart';

class CurvedPainter extends CustomPainter {
  final int totuIndex;
  CurvedPainter({this.totuIndex = 0});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = AppColors.base
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();

    switch (totuIndex) {
      case 2:
        path_0.moveTo(0, size.height * 0.9194250);
        path_0.quadraticBezierTo(
            size.width * 0.0538200,
            size.height * 0.9497625,
            size.width * 0.1452400,
            size.height * 0.9593875);
        path_0.cubicTo(
            size.width * 0.2740000,
            size.height * 0.9748125,
            size.width * 0.5977400,
            size.height * 0.8539250,
            size.width * 0.7701400,
            size.height * 0.8279250);
        path_0.quadraticBezierTo(size.width * 0.8842600,
            size.height * 0.8107625, size.width, size.height * 0.8618750);
        path_0.lineTo(size.width, 0);
        path_0.lineTo(0, 0);
        path_0.lineTo(0, size.height * 0.9194250);
        break;
      case 1:
        path_0.moveTo(0, size.height * 0.8626875);
        path_0.quadraticBezierTo(
            size.width * 0.1042000,
            size.height * 0.8390750,
            size.width * 0.2072400,
            size.height * 0.8476875);
        path_0.cubicTo(
            size.width * 0.4019000,
            size.height * 0.8665625,
            size.width * 0.4903200,
            size.height * 0.9441375,
            size.width * 0.7095000,
            size.height * 0.9381750);
        path_0.quadraticBezierTo(size.width * 0.8685600,
            size.height * 0.9310750, size.width, size.height * 0.8789500);
        path_0.lineTo(size.width, 0);
        path_0.lineTo(0, 0);
        path_0.lineTo(0, size.height * 0.8626875);
        break;
      case 0:
        path_0.moveTo(0, size.height * 0.8769625);
        path_0.quadraticBezierTo(
            size.width * 0.0702800,
            size.height * 0.9251625,
            size.width * 0.1714400,
            size.height * 0.9375500);
        path_0.cubicTo(
            size.width * 0.3267400,
            size.height * 0.9597750,
            size.width * 0.5592600,
            size.height * 0.8618750,
            size.width * 0.7352800,
            size.height * 0.8244500);
        path_0.quadraticBezierTo(size.width * 0.8874600,
            size.height * 0.7936500, size.width, size.height * 0.8439000);
        path_0.lineTo(size.width, size.height * 0.0003125);
        path_0.lineTo(0, 0);
        break;
      default:
        path_0.moveTo(0, size.height * 0.7281375);
        path_0.quadraticBezierTo(
            size.width * 0.0402800,
            size.height * 0.8081125,
            size.width * 0.1527200,
            size.height * 0.8501875);
        path_0.cubicTo(
            size.width * 0.2546400,
            size.height * 0.8880125,
            size.width * 0.4557600,
            size.height * 0.9080500,
            size.width * 0.7202800,
            size.height * 0.8850375);
        path_0.quadraticBezierTo(size.width * 0.8682400,
            size.height * 0.8724000, size.width, size.height * 0.9128625);
        path_0.lineTo(size.width, size.height * 0.0003125);
        path_0.lineTo(size.width * 0.0002800, size.height * 0.0000375);
        path_0.lineTo(size.width * 0, size.height * 0.7281375);
        break;
    }

    path_0.close();
    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
