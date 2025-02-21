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
          UserInfoSection(_currentUser),
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
