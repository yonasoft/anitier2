import 'package:firebase_auth/firebase_auth.dart'
    hide
        EmailAuthProvider,
        PhoneAuthProvider,
        FacebookAuthProvider,
        GithubAuthProvider,
        AuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

Future<List<AuthProvider>> getAuthProviders(User user) async {
  final List<AuthProvider> providers = [];

  for (final providerInfo in user.providerData) {
    switch (providerInfo.providerId) {
      case 'google.com':
        providers.add(GoogleProvider(
            clientId: kIsWeb
                ? const String.fromEnvironment('GOOGLE_CLIENT_ID')
                : dotenv.env['GOOGLE_CLIENT_ID']!));
        break;
      case 'facebook.com':
        providers.add(FacebookProvider(
            clientId: kIsWeb
                ? const String.fromEnvironment('FACEBOOK_CLIENT_ID')
                : dotenv.env['FACEBOOK_CLIENT_ID']!));
        break;
      case 'password':
        providers.add(EmailAuthProvider());
        break;
      case 'phone':
        providers.add(PhoneAuthProvider());
        break;
      default:
        break;
    }
  }

  return providers;
}

Future<bool> deleteExistingUserPhoto() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null || currentUser.photoURL == null) {
    return false;
  }

  final photoURL = currentUser.photoURL!;
  try {
    final decodedPath = Uri.decodeFull(Uri.parse(photoURL).path);
    final bucketPath = decodedPath.split('/o/').last.split('?').first;

    final fileRef = FirebaseStorage.instance.ref().child(bucketPath);

    await fileRef.getMetadata();

    await fileRef.delete();
    return true;
  } on FirebaseException catch (e) {
    if (e.code == 'object-not-found') {
      return false;
    }
    throw e;
  }
}
