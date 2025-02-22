import 'package:anitier2/src/features/account/presentation/widgets/user_info_section.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrentUserPage extends StatefulWidget {
  const CurrentUserPage({super.key});

  @override
  State<CurrentUserPage> createState() => _CurrentUserPageState();
}

class _CurrentUserPageState extends State<CurrentUserPage> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfoArea = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          UserInfoSection(user: _currentUser!),
          Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: Divider()),
          OutlinedButton(
              onPressed: () => showChangePasswordDialog(context),
              child: Text('Change Password')),
        ],
      ),
    );

    return LayoutBuilder(builder: (context, constraints) {
      return (constraints.maxWidth >= 600)
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Text('test')),
              VerticalDivider(thickness: 1),
              SingleChildScrollView(
                child: SizedBox(width: 280, child: userInfoArea),
              )
            ])
          : SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                userInfoArea,
              ]),
            );
    });
  }
}

Future<void> showChangePasswordDialog(BuildContext context) async {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String errorMessage = "";

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Change Password'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Enter new password',
                      errorText: errorMessage.isNotEmpty ? errorMessage : null,
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm new password',
                      errorText: errorMessage.isNotEmpty ? errorMessage : null,
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newPassword = newPasswordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();
                  if (newPassword.isEmpty || confirmPassword.isEmpty) {
                    setState(() {
                      errorMessage = "Both fields are required";
                    });
                    return;
                  }

                  if (newPassword.length < 6) {
                    setState(() {
                      errorMessage =
                          "Password must be at least 6 characters long";
                    });
                    return;
                  }

                  if (newPassword != confirmPassword) {
                    setState(() {
                      errorMessage = "Passwords do not match";
                    });
                    return;
                  }

                  try {
                    await FirebaseAuth.instance.currentUser
                        ?.updatePassword(newPassword);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password changed successfully')),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    setState(() {
                      errorMessage =
                          "Failed to change password: ${e.toString()}";
                    });
                  }
                },
                child: Text('Change'),
              ),
            ],
          );
        },
      );
    },
  );
}
