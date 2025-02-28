import 'package:flutter/material.dart';

class UserProfileAvatar extends StatelessWidget {
  final String? avatar;

  const UserProfileAvatar(
    this.avatar, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("avatar: $avatar");
    return CircleAvatar(
      minRadius: 56,
      child: ClipOval(
        child: avatar != null
            ? Image.network(
                avatar!,
                fit: BoxFit.cover,
                width: 112,
                height: 112,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const CircularProgressIndicator();
                },
                errorBuilder: (context, url, error) {
                  return const Icon(Icons.account_circle, size: 56);
                },
              )
            : Icon(Icons.account_circle, size: 56),
      ),
    );
  }
}
