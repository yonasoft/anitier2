import 'package:anitier2/src/features/account/presentation/pages/account_settings.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide
        EmailAuthProvider,
        PhoneAuthProvider,
        FacebookAuthProvider,
        GithubAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
        } else if (!snapshot.hasData) {
          return SignInScreen(
            auth: FirebaseAuth.instance,
            providers: [
              GoogleProvider(
                  clientId: kIsWeb
                      ? const String.fromEnvironment('GOOGLE_CLIENT_ID')
                      : dotenv.env['GOOGLE_CLIENT_ID']!),
              FacebookProvider(
                  clientId: kIsWeb
                      ? const String.fromEnvironment('FACEBOOK_CLIENT_ID')
                      : dotenv.env['FACEBOOK_CLIENT_ID']!),
              EmailAuthProvider(),
              PhoneAuthProvider(),
            ],
            footerBuilder: (context, _) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    const Text('Or'),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.signInAnonymously();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                      child: const Text('Continue as Guest'),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const AccountSettings();
      },
    );
  }
}
