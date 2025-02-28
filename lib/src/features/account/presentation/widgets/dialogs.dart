import 'dart:io';
import 'package:anitier2/src/core/constants.dart';
import 'package:anitier2/src/features/account/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

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
                  final User user = FirebaseAuth.instance.currentUser!;
                  final DatabaseReference userRef =
                      FirebaseDatabase.instance.ref('users/${user.uid}');
                  await FirebaseAuth.instance.currentUser?.reload();
                  await userRef.get().then((snapshot) {
                    if (!snapshot.exists) {
                      userRef.set({
                        'displayName': nameController.text,
                      });
                    } else {
                      userRef.update({
                        'displayName': nameController.text,
                      });
                    }
                  });
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
  File? imageFile;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Avatar'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  try {
                    final pickedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    imageFile = File(pickedImage!.path);
                    final bytes = await pickedImage.readAsBytes();
                    final storageRef = FirebaseStorage.instance.ref();
                    final profilePictureRef = storageRef.child(
                        "/users/${FirebaseAuth.instance.currentUser!.uid}/${Uuid().v4()}");
                    await deleteExistingUserPhoto();
                    final taskSnapshot = await profilePictureRef.putData(
                      bytes,
                    );
                    final downloadURL =
                        await profilePictureRef.getDownloadURL();

                    await FirebaseAuth.instance.currentUser
                        ?.updatePhotoURL(downloadURL);
                    await FirebaseAuth.instance.currentUser!.reload();
                  } on FirebaseException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Error: ${e.message}",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  } finally {
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(Icons.photo_library),
                label: Text('Pick from device'),
              ),
            ],
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
              var message = "URL is empty or choose from gallery!";
              if (urlController.text.isNotEmpty) {
                try {
                  print(
                      "Attempting to update profile with URL: ${urlController.text}");

                  await FirebaseAuth.instance.currentUser
                      ?.updatePhotoURL(urlController.text);
                  await FirebaseAuth.instance.currentUser!.reload();
                  await deleteExistingUserPhoto();

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

Future<bool> showDeleteConfirmationDialog(
    BuildContext context, String userEmail) async {
  final deleteTextController = TextEditingController();
  final emailController = TextEditingController();

  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              String? deleteTextError;
              String? emailError;

              Future<void> validateAndSubmit() async {
                final deleteText = deleteTextController.text.trim();
                final email = emailController.text.trim();

                setState(() {
                  deleteTextError = null;
                  emailError = null;

                  if (deleteText != "delete account") {
                    deleteTextError = "Please type 'delete account'.";
                  }
                  if (email != userEmail) {
                    emailError = "Email does not match.";
                  }
                });

                if (deleteTextError == null && emailError == null) {
                  final user = FirebaseAuth.instance.currentUser!;
                  await deleteExistingUserPhoto();

                  final DatabaseReference userRef =
                      FirebaseDatabase.instance.ref('users/${user.uid}');
                  await userRef.get().then((snapshot) {
                    if (snapshot.exists) {
                      userRef.remove();
                    }
                  });
                  user.delete();
                  Navigator.of(context).pop(true);
                }
              }

              return AlertDialog(
                title: Text("Confirm Deletion"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: deleteTextController,
                      decoration: InputDecoration(
                        labelText: "Type 'delete account'",
                        errorText: deleteTextError,
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Enter your email",
                        errorText: emailError,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: validateAndSubmit,
                    child: Text("Confirm"),
                  ),
                ],
              );
            },
          );
        },
      ) ??
      false;
}
