import 'package:anitier2/src/core/constants.dart';
import 'package:anitier2/src/features/account/presentation/widgets/dialogs.dart';
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
          GestureDetector(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    textAlign: TextAlign.center,
                    currentUser?.displayName ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                Icon(Icons.edit),
              ],
            ),
            onTap: () async {
              await showChangeDisplayNameDialog(context);
            },
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
