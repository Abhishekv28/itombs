import 'package:itombs/library.dart';

class CacheImageWidget extends StatelessWidget {
  final String url;
  final double size;
  final double radius;
  final double padding;
  final bool isProfile;
  CacheImageWidget(
      {Key key,
      this.url,
      this.size,
      this.radius = 10,
      this.padding = 20,
      this.isProfile = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: url.isEmpty
            ? Image.asset(
                isProfile
                    ? 'assets/graphics/non_profile.png'
                    : 'assets/graphics/img_not_available.jpeg',
                width: size,
                height: size,
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                placeholder: (context, url) => Container(
                  color: AppColors.base,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  width: size,
                  height: size,
                  padding: EdgeInsets.all(padding),
                ),
                useOldImageOnUrlChange: true,
                errorWidget: (context, url, error) => Material(
                  child: Image.asset(
                    isProfile
                        ? 'assets/graphics/non_profile.png'
                        : 'assets/graphics/img_not_available.jpeg',
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                imageUrl: url,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ));
  }
}
