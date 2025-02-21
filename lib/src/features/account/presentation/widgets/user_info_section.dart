import 'package:anitier2/src/core/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserInfoSection extends StatefulWidget {
  const UserInfoSection({super.key});

  @override
  State<UserInfoSection> createState() => _UserInfoSectionState();
}

class _UserInfoSectionState extends State<UserInfoSection> {
  User? _currentUser;
  String? _avatar;
  String? _displayName;
  String? _email;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _avatar = _currentUser?.photoURL;
    _displayName = _currentUser?.displayName;
    _email = _currentUser?.email;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
          _avatar = _currentUser?.photoURL;
          _displayName = _currentUser?.displayName;
          _email = _currentUser?.email;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            minRadius: 56,
            child: ClipOval(
              child: _avatar != null
                  ? CachedNetworkImage(
                      imageUrl: _avatar!,
                      fit: BoxFit.cover,
                      width: 112,
                      height: 112,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.account_circle, size: 56),
                    )
                  : Icon(Icons.account_circle, size: 56),
            ),
          ),
          SizedBox(height: 12),
          Text(_displayName ?? "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          SizedBox(height: 8),
          Text(_email ?? "", style: TextStyle(fontSize: 14)),
          SizedBox(height: 12),
          ElevatedButton.icon(
              onPressed: () async {
                bool shouldSignOut = await showDialog(
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
                );

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
