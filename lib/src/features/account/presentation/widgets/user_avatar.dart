import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfileAvatar extends StatelessWidget {
  final String? avatar;

  const UserProfileAvatar(
    this.avatar, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      minRadius: 56,
      child: ClipOval(
        child: avatar != null
            ? CachedNetworkImage(
                imageUrl: avatar!,
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
    );
  }
}
