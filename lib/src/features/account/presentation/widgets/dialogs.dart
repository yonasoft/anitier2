

import 'package:anitier2/src/core/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> showChangeDisplayNameDialog(BuildContext context) async {
  TextEditingController nameController = TextEditingController();
  
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Change Display Name'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Enter new display name',
            hintText: 'John Doe',
          ),
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
              if (nameController.text.isNotEmpty) {
                try {
                  await FirebaseAuth.instance.currentUser
                      ?.updateDisplayName(nameController.text);
                  await FirebaseAuth.instance.currentUser?.reload();
                  
                  final snackBar = SnackBar(
                    content: Text('Display name updated successfully!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } catch (e) {
                  print("Failed to update display name: $e");
                  final snackBar = SnackBar(
                    content: Text('Failed to update display name!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
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