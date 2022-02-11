import 'dart:io';

import 'package:intl/intl.dart';
import 'package:itombs/library.dart';

class ItombCreatePage extends StatefulWidget {
  final ItombModel itomb;
  ItombCreatePage({Key key, this.itomb});

  @override
  ItombCreatePageState createState() => new ItombCreatePageState();
}

class ItombCreatePageState extends State<ItombCreatePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController charityController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode aboutFocus = FocusNode();
  FocusNode charityFocus = FocusNode();
  bool isFirst = true;
  String profileImagePath = '';

  DateTime dateOfBirth, dateOfPassed;
  static const double padding = 30, width = 250, gapOfDate = 20;
  final labelWeight = FontWeight.w600;

  ItombProvider itombProvider;

  final String defaultDate = '1900-01-01';

  @override
  void initState() {
    super.initState();
    itombProvider = Provider.of<ItombProvider>(context, listen: false);
    if (widget.itomb != null) {
      nameController.text = widget.itomb.name;
      aboutController.text = widget.itomb.bio;
      dateOfBirth = DateFormat("yyyy-MM-dd").parse(widget.itomb.dateOfBirth);
      if (widget.itomb.dateOfPass != defaultDate) {
        dateOfPassed = DateFormat("yyyy-MM-dd").parse(widget.itomb.dateOfPass);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MyTextButton(
                label: 'Back',
                icon: Icons.arrow_back_ios,
                fontWeight: FontWeight.normal,
                action: () => Navigator.pop(context),
              ),
              Expanded(
                  child: Text(
                widget.itomb == null ? 'Create an iTomb' : 'Edit iTomb',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.base),
              )),
              MyTextButton(
                label: '',
                icon: null,
                fontWeight: FontWeight.normal,
                fontSize: 25,
                align: MainAxisAlignment.end,
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: max(MediaQuery.of(context).size.height, 900.0),
              padding: const EdgeInsets.only(
                  top: 30, left: 20, right: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet<int>(
                          backgroundColor: Colors.transparent,
                          barrierColor:
                              AppColors.textHintColor.withOpacity(0.5),
                          context: context,
                          builder: (context) {
                            return BottomSheetMenu(
                                length: 2,
                                title: 'Please take card photo from',
                                labels: [
                                  'Gallery',
                                  'Camera'
                                ],
                                icons: [
                                  Icons.photo_album,
                                  Icons.camera
                                ],
                                actions: [
                                  () async {
                                    profileImagePath =
                                        await UtilProvider().getImage(false);

                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  () async {
                                    profileImagePath =
                                        await UtilProvider().getImage(true);

                                    Navigator.pop(context);
                                    setState(() {});
                                  }
                                ]);
                          },
                        );
                      },
                      child: profileImagePath.isEmpty
                          ? widget.itomb == null
                              ? Image.asset('assets/graphics/add_photo.png')
                              : CacheImageWidget(
                                  url: widget.itomb.photo, size: 90, radius: 10)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: new Image(
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.fill,
                                  image: FileImage(File(profileImagePath))),
                            )),
                  const SizedBox(height: padding),
                  MainInputWidget(
                    width: double.infinity,
                    height: 50,
                    focusNode: nameFocus,
                    controller: nameController,
                    isNullStr: !isFirst && nameController.text.isEmpty,
                    label: 'Name',
                    icon: FontAwesomeIcons.userAlt,
                    iconColor: Colors.grey.withOpacity(0.5),
                    labelWeight: labelWeight,
                  ),
                  const SizedBox(height: padding),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: Text('Birthday',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textColor,
                                  fontWeight: labelWeight)))),
                  Row(children: [
                    Expanded(
                        flex: 1,
                        child: DateButtonWidget(
                          width: double.infinity,
                          height: 50,
                          colorLabel: dateOfBirth == null
                              ? Colors.grey.withOpacity(0.5)
                              : AppColors.textColor,
                          label: dateOfBirth == null
                              ? 'Month'
                              : DateFormat('MMM').format(dateOfBirth),
                          titleOfDatePicker: 'Select Birthday',
                          currentDate: dateOfBirth,
                          action: (birthday) {
                            setState(() {
                              dateOfBirth = birthday;
                            });
                          },
                        )),
                    const SizedBox(width: gapOfDate),
                    Expanded(
                        flex: 1,
                        child: DateButtonWidget(
                          width: double.infinity,
                          height: 50,
                          colorLabel: dateOfBirth == null
                              ? Colors.grey.withOpacity(0.5)
                              : AppColors.textColor,
                          label: dateOfBirth == null
                              ? 'Day'
                              : DateFormat('dd').format(dateOfBirth),
                          titleOfDatePicker: 'Select Birthday',
                          currentDate: dateOfBirth,
                          action: (birthday) {
                            setState(() {
                              dateOfBirth = birthday;
                            });
                          },
                        )),
                    const SizedBox(width: gapOfDate),
                    Expanded(
                        flex: 1,
                        child: DateButtonWidget(
                          width: double.infinity,
                          height: 50,
                          colorLabel: dateOfBirth == null
                              ? Colors.grey.withOpacity(0.5)
                              : AppColors.textColor,
                          label: dateOfBirth == null
                              ? 'Year'
                              : DateFormat('yyyy').format(dateOfBirth),
                          titleOfDatePicker: 'Select Birthday',
                          currentDate: dateOfBirth,
                          action: (birthday) {
                            setState(() {
                              dateOfBirth = birthday;
                            });
                          },
                        )),
                  ]),
                  const SizedBox(height: padding),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: Text('Date of Passing(optional)',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textColor,
                                  fontWeight: labelWeight)))),
                  Row(children: [
                    Expanded(
                        flex: 1,
                        child: DateButtonWidget(
                          width: double.infinity,
                          height: 50,
                          colorLabel: dateOfPassed == null
                              ? Colors.grey.withOpacity(0.5)
                              : AppColors.textColor,
                          label: dateOfPassed == null
                              ? 'Month'
                              : DateFormat('MMM').format(dateOfPassed),
                          titleOfDatePicker: 'Select Passed Day',
                          currentDate: dateOfPassed,
                          action: (passedDay) {
                            setState(() {
                              dateOfPassed = passedDay;
                            });
                          },
                        )),
                    const SizedBox(width: gapOfDate),
                    Expanded(
                        flex: 1,
                        child: DateButtonWidget(
                            width: double.infinity,
                            height: 50,
                            colorLabel: dateOfPassed == null
                                ? Colors.grey.withOpacity(0.5)
                                : AppColors.textColor,
                            label: dateOfPassed == null
                                ? 'Day'
                                : DateFormat('dd').format(dateOfPassed),
                            titleOfDatePicker: 'Select Passed Day',
                            currentDate: dateOfPassed,
                            action: (passedDay) {
                              setState(() {
                                dateOfPassed = passedDay;
                              });
                            })),
                    const SizedBox(width: gapOfDate),
                    Expanded(
                        flex: 1,
                        child: DateButtonWidget(
                            width: double.infinity,
                            height: 50,
                            colorLabel: dateOfPassed == null
                                ? Colors.grey.withOpacity(0.5)
                                : AppColors.textColor,
                            label: dateOfPassed == null
                                ? 'Year'
                                : DateFormat('yyyy').format(dateOfPassed),
                            titleOfDatePicker: 'Select Passed Day',
                            currentDate: dateOfPassed,
                            action: (passedDay) {
                              setState(() {
                                dateOfPassed = passedDay;
                              });
                            })),
                  ]),
                  const SizedBox(height: padding),
                  MainInputWidget(
                    width: double.infinity,
                    height: 120,
                    maxLines: 5,
                    focusNode: aboutFocus,
                    controller: aboutController,
                    isNullStr: !isFirst && aboutController.text.isEmpty,
                    label: 'About/Obituary',
                    hint: 'Start Typing...',
                    labelWeight: labelWeight,
                  ),
                  const SizedBox(height: padding),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Link a Charity(optional)',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: AppColors.textColor,
                                        fontWeight: labelWeight)),
                                Text(
                                    'If you would like people to donate to a charity in your loved one’s honor in lieu of gifts, please add the website to the charity of your choice.',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textHintColor)),
                                const SizedBox(height: 5),
                                MainInputWidget(
                                  width: double.infinity,
                                  height: 50,
                                  focusNode: charityFocus,
                                  controller: charityController,
                                  isNullStr: !isFirst &&
                                      charityController.text.isEmpty,
                                  hint: 'Add Website',
                                  labelWeight: labelWeight,
                                ),
                              ]))),
                  const SizedBox(height: 50),
                  RoundButton(
                    label: 'Next',
                    color: AppColors.base,
                    action: () async {
                      FocusScope.of(context).unfocus();
                      if (nameController.text.isEmpty ||
                          aboutController.text.isEmpty) {
                        setState(() {
                          isFirst = false;
                        });
                        return;
                      }
                      if (dateOfBirth == null) {
                        UtilProvider().showToast(context, 'Input birthday');
                        return;
                      }
                      String photo = '';
                      if (profileImagePath.isEmpty) {
                        if (widget.itomb == null) {
                          UtilProvider().showToast(context, 'Select a photo');
                          return;
                        } else {
                          photo = widget.itomb.photo
                              .split('assets/')
                              .last
                              .split('.')
                              .first;
                        }
                      } else {
                        photo = await UtilProvider()
                            .fileUpload(context, profileImagePath);
                      }

                      var params = {
                        "name": nameController.text,
                        "dob": DateFormat('yyyy-MM-dd').format(dateOfBirth),
                        "dop": dateOfPassed == null
                            ? defaultDate
                            : DateFormat('yyyy-MM-dd').format(dateOfPassed),
                        "bio": aboutController.text,
                        "photo": [photo],
                        "gender": "MALE"
                      };
                      if (widget.itomb != null) params['id'] = widget.itomb.id;
                      final status = await itombProvider.create(context, params,
                          isUpdate: widget.itomb != null);
                      if (status)
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              )),
        ));
  }
}
