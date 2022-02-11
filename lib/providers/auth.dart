import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:itombs/library.dart';

class AuthProvider extends ChangeNotifier {
  static UserModel user;

  Future<bool> login(
      BuildContext context, String email, String password) async {
    UtilProvider().showProgressing(context);
    final params = {"email": email, "password": password};
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.login, params);
    Navigator.pop(context);
    if (result.data != null && result.data['generateAccessToken'] != null) {
      UtilProvider.userToken = result.data['generateAccessToken']['token'];
      user = UserModel.fromJson(result.data['generateAccessToken']['user']);
      saveAuth(false, email, password);
      UtilProvider().initClient();
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              duration:
                  const Duration(milliseconds: AppConstants.timeOfPagination),
              type: AppConstants.typeOfPagination,
              child: HomePage()),
          (route) => false);

      return true;
    } else {
      UtilProvider().showToast(context, 'Invalid email or password');
      return false;
    }
  }

  Future<bool> register(BuildContext context, String email, String name,
      String photo, String password) async {
    UtilProvider().showProgressing(context);
    final params = {
      "email": email,
      "name": name,
      "photo": photo,
      "password": password
    };
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.register, params);
    Navigator.pop(context);
    if (result.data != null && result.data['addUser'] != null) {
      UtilProvider.userToken = result.data['addUser']['token'];
      user = UserModel.fromJson(result.data['addUser']['user']);
      saveAuth(false, email, password);
      UtilProvider().initClient();
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              duration:
                  const Duration(milliseconds: AppConstants.timeOfPagination),
              type: AppConstants.typeOfPagination,
              child: HomePage()),
          (route) => false);
      return true;
    } else {
      UtilProvider().showToast(context, 'Email is already taken');
      return false;
    }
  }

  Future<bool> socialSign(BuildContext context, String social, String email,
      String name, String token, String photo) async {
    UtilProvider().showProgressing(context);
    final params = {
      "provider": social,
      "token": token,
      "email": email,
      "name": name
    };
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.socialSign, params);
    Navigator.pop(context);
    if (result.data != null && result.data['addUserBySocial'] != null) {
      UtilProvider.userToken = result.data['addUserBySocial']['token'];
      user = UserModel.fromJson(result.data['addUserBySocial']['user']);
      saveAuth(true, social, token);
      UtilProvider().initClient();
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              duration:
                  const Duration(milliseconds: AppConstants.timeOfPagination),
              type: AppConstants.typeOfPagination,
              child: HomePage()),
          (route) => false);
      return true;
    } else {
      UtilProvider().showToast(context, 'Invalid email or password');
      return false;
    }
  }

  Future<bool> facebookSign(BuildContext context) async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['public_profile', 'email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.9/me?fields=name,email,picture,first_name,last_name&access_token=${accessToken.token}');

        final profile = json.decode(graphResponse.body);
        final email = profile['email'] ??
            '${profile['name'].toString().replaceAll(' ', '').toLowerCase()}@${profile['id']}.com';
        final token = profile['id'];
        final photo =
            profile['picture'] != null ? profile['picture']['data']['url'] : '';
        final name = profile['name'].replaceAll(' ', '');
        final status =
            await socialSign(context, 'FACEBOOK', email, name, token, photo);
        return status;
        break;
      case FacebookLoginStatus.cancelledByUser:
        UtilProvider().showToast(context, 'Login cancelled by the user.');
        return false;
        break;
      case FacebookLoginStatus.error:
        UtilProvider().showToast(
            context,
            'Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        return false;
        break;
    }
  }

  Future<bool> googleSign(BuildContext context) async {
    final FirebaseAuth fbAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await fbAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await fbAuth.currentUser();
    assert(user.uid == currentUser.uid);
    final email = user.email;
    final token = user.uid;
    final name = user.displayName.replaceAll(' ', '');
    final photo = user.photoUrl ?? '';
    final status =
        await socialSign(context, 'GOOGLE', email, name, token, photo);
    return status;
  }

  Future<bool> appleSign(BuildContext context) async {
    if (await AppleSignIn.isAvailable()) {
      final result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [
          Scope.email,
          Scope.fullName,
        ])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential;
          final email = appleIdCredential.email ?? 'x';
          final token = appleIdCredential.user.toString();
          String name =
              '${appleIdCredential.fullName.givenName != null ? appleIdCredential.fullName.givenName : ''}${appleIdCredential.fullName.familyName != null ? appleIdCredential.fullName.familyName : ''}'
                  .replaceAll(' ', '');
          if (name.isEmpty) name = 'x';
          final photo = '';

          final status =
              await socialSign(context, 'APPLE', email, name, token, photo);
          return status;

          break;
        case AuthorizationStatus.error:
          UtilProvider()
              .showToast(context, 'Unenable to authenticate with apple');
          return false;
          break;

        case AuthorizationStatus.cancelled:
          UtilProvider().showToast(context, 'Login cancelled by the user.');
          return false;
          break;
        default:
          throw UnimplementedError();
      }
    } else {
      UtilProvider().showToast(context, 'Unenable to authenticate with apple');
      return false;
    }
  }

  Future<String> requestResetPassword(
      BuildContext context, String email) async {
    UtilProvider().showProgressing(context);
    final params = {"email": email};
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.requestResetPassword, params);
    Navigator.pop(context);
    if (result.data != null && result.data['requestResetPassword'] != null) {
      UtilProvider().showToast(
          context, 'We sent a verify code to your email. Please check it');
      return result.data['requestResetPassword']['code'];
    } else {
      UtilProvider().showToast(context, 'Invalid Email');
      return '';
    }
  }

  Future<bool> changePassword(
      BuildContext context, String email, String password,
      {String verifyCode = '', String oldPassword = ''}) async {
    UtilProvider().showProgressing(context);
    final params = {"email": email, "newPassword": password};
    if (verifyCode.isNotEmpty) params['code'] = verifyCode;
    if (oldPassword.isNotEmpty) params['password'] = oldPassword;
    final QueryResult result = await UtilProvider().gqRequest(
        verifyCode.isNotEmpty
            ? Queries.changePassword
            : Queries.changePasswordWithOldPwd,
        params);
    Navigator.pop(context);
    if (result.data != null && result.data['changePassword']) {
      UtilProvider().showToast(context, 'Success to change password');
      await SharedPreferences.getInstance().then((value) {
        value.setString(Strings.key_auth_password, password);
      });
      return true;
    } else {
      UtilProvider().showToast(context, 'Invalid Email');
      return false;
    }
  }

  Future<void> saveAuth(bool isSocial, String email, String password) async {
    await SharedPreferences.getInstance().then((value) {
      value.setBool(Strings.key_auth_is_social, isSocial);
      value.setString(Strings.key_auth_email, email);
      value.setString(Strings.key_auth_password, password);
    });
  }

  Future<void> updateProfile(BuildContext context,
      {String photo = '', String email = '', String name = ''}) async {
    Map<String, dynamic> params = {};

    if (photo.isNotEmpty) {
      params = {'photo': photo};
    } else {
      params = {
        'email': email.isEmpty ? user.email : email,
        'name': name.isEmpty ? user.name : name
      };
    }
    UtilProvider().showProgressing(context);
    final QueryResult result = await UtilProvider().gqRequest(
        photo.isNotEmpty ? Queries.updateProfilePhoto : Queries.updateProfile,
        params);
    Navigator.pop(context);
    if (result.data != null && result.data['updateUser'] != null) {
      user = UserModel.fromJson(result.data['updateUser']);
    } else {
      UtilProvider().showToast(context, 'Invalid data');
    }
    notifyListeners();
  }

  Future<bool> addFeedback(BuildContext context, dynamic params) async {
    UtilProvider().showProgressing(context);
    final QueryResult result =
        await UtilProvider().gqRequest(Queries.addFeedbck, params);
    Navigator.pop(context);
    if (result.data != null && result.data['updateFeedback'] != null) {
      UtilProvider().showToast(context, 'Success to submit feedback');
      return true;
    } else {
      UtilProvider().showToast(context, 'Failed to submit feedback');
      return true;
    }
  }

  Future<void> logOut(BuildContext context) async {
    Provider.of<ItombProvider>(context, listen: false).clear();
    Provider.of<ChatProvider>(context, listen: false).clear();
    Provider.of<MessageProvider>(context, listen: false).clear();
    UtilProvider.selectedPageIndex = 0;
    await SharedPreferences.getInstance().then((value) {
      value.setBool(Strings.key_auth_is_social, false);
      value.setString(Strings.key_auth_email, '');
      value.setString(Strings.key_auth_password, '');
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              duration:
                  const Duration(milliseconds: AppConstants.timeOfPagination),
              type: AppConstants.typeOfPagination,
              child: LoginPage()),
          (route) => false);
    });
  }
}
