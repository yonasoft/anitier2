import 'package:anitier2/src/core/constants.dart';
import 'package:anitier2/src/features/account/presentation/widgets/user_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class UserInfoSection extends StatelessWidget {
  final User? _user;
  const UserInfoSection(this._user, {super.key});

  @override
  Widget build(BuildContext context) {
    final String? avatar = _user?.photoURL;
    final String? displayName = _user?.displayName;
    final String? email = _user?.email;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserProfileAvatar(avatar),
          SizedBox(height: 12),
          Text(displayName ?? "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          SizedBox(height: 8),
          Text(email ?? "", style: TextStyle(fontSize: 14)),
          SizedBox(height: 12),
          ElevatedButton.icon(
              onPressed: () async {
                bool shouldSignOut = await showSignOutDialog(context);

                if (shouldSignOut == true) {
                  FirebaseAuth.instance.signOut();
                  FirebaseUIAuth.signOut();
                }
              },
              style: redButtonStyle,
              label: Text(
                "Sign out",
                style: TextStyle(color: Colors.red.shade300),
              ),
              icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}

Future<bool> showSignOutDialog(BuildContext context) async {
  return (await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Sign Out'),
            content: Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                style: redButtonStyle,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red.shade300),
                ),
              ),
            ],
          );
        },
      )) ??
      false;
}
