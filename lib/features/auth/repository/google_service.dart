import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/config/app_constants.dart';

class GoogleController extends GetxController {
  // Rx<pageState> status = pageState.initial.obs;
  late GoogleSignIn _googleSignIn;

  void initAuth() {
    final String googleClientId = GoogleClientID();
    // this is because we only need to config the `clientId` for web app,
    // android and ios are configured in their specific config files
    if (googleClientId == '') {
      _googleSignIn = GoogleSignIn(serverClientId: AppKey.googleServerClientId);
    } else {
      _googleSignIn = GoogleSignIn(
        serverClientId: AppKey.googleServerClientId,
        clientId: googleClientId,
      );
    }
  }

  Future<void> authWithGoogle({required bool isSignIn}) async {
    try {
      await _googleSignIn.signOut();
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication? _googleAuth = await googleSignInAccount?.authentication;

      if (googleSignInAccount != null && googleSignInAccount.serverAuthCode?.isNotEmpty == true) {
        print(_googleAuth?.idToken);
        print(googleSignInAccount.email);
        print(googleSignInAccount.displayName);

        await _googleSignIn.signOut();
      }
    } catch (e) {
      print('Error in Google sign-in: $e');
    }
  }
}