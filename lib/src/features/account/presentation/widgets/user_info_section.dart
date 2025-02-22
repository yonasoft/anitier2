import 'package:anitier2/src/core/constants.dart';
import 'package:anitier2/src/features/account/presentation/widgets/user_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class UserInfoSection extends StatefulWidget {
  final User user;
  const UserInfoSection({super.key, required this.user});

  @override
  State<UserInfoSection> createState() => _UserInfoSectionState();
}

class _UserInfoSectionState extends State<UserInfoSection> {
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> handleAvatarTap() async {
    await showAvatarSelectionDialog(context);
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final avatarWidget = UserProfileAvatar(currentUser?.photoURL ?? "");

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: avatarWidget,
            onTap: () async {
              if (widget.user.uid == currentUser?.uid) {
                await handleAvatarTap();
              }
            },
          ),
          const SizedBox(height: 8),
          Text(
            currentUser?.displayName ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            currentUser?.email ?? "",
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          if (widget.user.uid == currentUser?.uid)
            ElevatedButton.icon(
              onPressed: () async {
                bool shouldSignOut = await showSignOutDialog(context);

                if (shouldSignOut) {
                  await FirebaseAuth.instance.signOut();
                  await FirebaseUIAuth.signOut();
                  setState(() {
                    currentUser = null;
                  });
                }
              },
              style: redButtonStyle,
              label: Text(
                "Sign out",
                style: TextStyle(color: Colors.red.shade300),
              ),
              icon: const Icon(Icons.logout),
            )
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

Future<void> showAvatarSelectionDialog(BuildContext context) async {
  TextEditingController urlController = TextEditingController();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Avatar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'Enter Image URL',
                hintText: 'https://example.com/avatar.png',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.photo_library),
              label: Text('Pick from device'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              var message = "URL is empty or choose from gallery!";
              if (urlController.text.isNotEmpty) {
                try {
                  print(
                      "Attempting to update profile with URL: ${urlController.text}");

                  await FirebaseAuth.instance.currentUser
                      ?.updatePhotoURL(urlController.text);
                  await FirebaseAuth.instance.currentUser!.reload();

                  print("Update profile completed");

                  message = "Photo URL uploaded successfully!";
                } catch (e) {
                  print("Photo URL upload failed! Error: $e");
                  message = "Photo URL upload failed!";
                }
              }

              final snackBar = SnackBar(
                content: Text(message),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}
