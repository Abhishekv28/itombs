import 'package:itombs/library.dart';

class AuthInputWidget extends StatelessWidget {
  final double width;
  final double height;
  final FocusNode focusNode;
  final TextEditingController controller;
  final String label;
  final bool isNullStr;
  final bool isEditable;
  final IconData icon;
  final bool isPassword;
  final bool isHasSuffix;
  final IconData iconSuffix;
  final Function action;

  AuthInputWidget(
      {Key key,
      this.width,
      this.height,
      this.focusNode,
      this.controller,
      this.label,
      this.isNullStr = false,
      this.isEditable = true,
      this.icon,
      this.isPassword = false,
      this.isHasSuffix = false,
      this.iconSuffix,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: true,
        obscureText: isPassword,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.base, width: 1),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.base.withOpacity(0.5),
            ),
          ),
          hintText: label,
          hintStyle: TextStyle(
              color: isNullStr ? Colors.redAccent : Colors.grey, fontSize: 16),
          suffixIcon: isHasSuffix
              ? GestureDetector(
                  onTap: action,
                  child: Icon(
                    iconSuffix,
                    size: 18.0,
                    color: Colors.grey,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
