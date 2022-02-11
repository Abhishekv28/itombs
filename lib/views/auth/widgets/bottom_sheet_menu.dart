import 'package:itombs/library.dart';

class BottomSheetMenu extends StatelessWidget {
  final int length;
  final String title;
  final bool isListMenu;
  final bool isHasTopButtons;
  final List<String> labels;
  final List<IconData> icons;
  final List<Function> actions;
  final Widget child;
  final String labelForTopLeft;
  final String labelForTopRight;
  final Function actionForTopLeft;
  final Function actionForTopRight;

  BottomSheetMenu(
      {Key key,
      this.length,
      this.title,
      this.isListMenu = true,
      this.isHasTopButtons = false,
      this.labels,
      this.icons,
      this.actions,
      this.child,
      this.labelForTopLeft,
      this.labelForTopRight,
      this.actionForTopLeft,
      this.actionForTopRight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(length + 2, (index) {
          switch (index) {
            case 0:
              return isHasTopButtons
                  ? topButtons(context)
                  : SheetTopHandleWidget();
            case 1:
              return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, top: 10, right: 5, left: 5),
                  child: Column(
                    children: [
                      Text(title,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 18, color: AppColors.base)),
                      const SizedBox(height: 20),
                      Divider(color: AppColors.textHintColor, thickness: 1)
                    ],
                  ));
            default:
              return isListMenu
                  ? bottomSheetListItem(
                      title: labels[index - 2],
                      icon: icons[index - 2],
                      isShowBorder: index != length + 1,
                      action: actions[index - 2])
                  : child;
          }
        }),
      ),
    );
  }

  Widget topButtons(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
                onPressed: this.actionForTopLeft,
                child: Text(this.labelForTopLeft,
                    style: TextStyle(color: Colors.redAccent, fontSize: 17))),
            FlatButton(
                onPressed: this.actionForTopRight,
                child: Text(
                  this.labelForTopRight,
                  style: TextStyle(color: Colors.blueAccent, fontSize: 17),
                )),
          ],
        ),
      );
}

Widget bottomSheetListItem(
    {String title, IconData icon, bool isShowBorder = true, Function action}) {
  return FlatButton(
      onPressed: action,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 15.0,
        ),
        decoration: BoxDecoration(
          border: isShowBorder
              ? Border(
                  bottom: BorderSide(
                    color: AppColors.textHintColor,
                    width: 0.5,
                  ),
                )
              : Border(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (icon != null) Icon(icon, color: AppColors.textHintColor),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Text(title),
            ),
          ],
        ),
      ));
}
