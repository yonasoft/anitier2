import 'package:anitier2/src/features/account/presentation/widgets/user_info_section.dart';
import 'package:flutter/material.dart';

class CurrentUserPage extends StatelessWidget {
  const CurrentUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    const userInfo = UserInfoSection();

    return LayoutBuilder(builder: (context, constraints) {
      return (constraints.maxWidth >= 600)
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Text('test')),
              VerticalDivider(thickness: 1),
              SingleChildScrollView(
                child: SizedBox(
                    width: 280,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: userInfo,
                    )),
              )
            ])
          : SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: userInfo,
                )
              ]),
            );
    });
  }
}
