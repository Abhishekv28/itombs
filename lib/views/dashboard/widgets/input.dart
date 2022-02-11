import 'package:itombs/library.dart';

class MainInputWidget extends StatelessWidget {
  final double width;
  final double height;
  final FocusNode focusNode;
  final TextEditingController controller;
  final String label;
  final String hint;
  final FontWeight labelWeight;
  final int maxLines;
  final bool isNullStr;
  final bool isEditable;
  final IconData icon;
  final Color iconColor;
  final double fontLableSize, fontHintSize, fontSize;
  final double cornerRadius;
  final Function action;

  MainInputWidget(
      {Key key,
      this.width,
      this.height,
      this.focusNode,
      this.controller,
      this.label = '',
      this.hint = '',
      this.labelWeight = FontWeight.bold,
      this.maxLines = 1,
      this.isNullStr = false,
      this.isEditable = true,
      this.icon,
      this.iconColor = Colors.grey,
      this.fontHintSize = 15,
      this.fontLableSize = 15,
      this.fontSize = 15,
      this.cornerRadius = 10,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(label,
                  style: TextStyle(
                      fontSize: fontLableSize,
                      color: AppColors.textHintColor,
                      fontWeight: labelWeight))),
        SizedBox(
          height: height,
          width: width,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            enabled: true,
            maxLines: maxLines,
            style: TextStyle(fontSize: fontSize, color: AppColors.textColor),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(cornerRadius),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(cornerRadius),
              ),
              prefixIcon: icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10, right: 20),
                      child: Icon(
                        icon,
                        size: 20,
                        color: iconColor,
                      ),
                    )
                  : null,
              hintText: hint,
              hintStyle: TextStyle(
                  color: isNullStr ? Colors.redAccent : Colors.grey,
                  fontSize: fontHintSize),
            ),
          ),
        )
      ],
    );
  }
}
