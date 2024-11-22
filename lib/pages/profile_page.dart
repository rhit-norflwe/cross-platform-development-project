import 'dart:async';

import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';
import 'package:notesbysubject/component/profile_image.dart';
import 'package:notesbysubject/manager/auth_manager.dart';
import 'package:notesbysubject/manager/user_data_document_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final displayNameTextEditingController = TextEditingController();
  StreamSubscription? userDataSubscription;
  final _formKey = GlobalKey<FormState>();
  String? _updatedImageUrl;

  @override
  void initState() {
    super.initState();
    userDataSubscription = UserDataDocumentManager.instance.startListening(
      documentId: AuthManager.instance.uid,
      observer: () {
        setState(() {
          displayNameTextEditingController.text =
              UserDataDocumentManager.instance.displayName;
        });
      },
    );
  }

  @override
  void dispose() {
    displayNameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 30.0,
              ),
              ProfileImage(
                  imageUrl:
                      (_updatedImageUrl != null && _updatedImageUrl!.isNotEmpty)
                          ? _updatedImageUrl
                          : UserDataDocumentManager.instance.imageUrl),
              UploadButton(
                extensions: const ["jpg", "png"],
                mimeTypes: const ["image/jpeg", "image/png"],
                onError: (error, state) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error.toString()),
                  ));
                },
                onUploadComplete: (ref) async {
                  _updatedImageUrl = await ref.getDownloadURL();
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextFormField(
                controller: displayNameTextEditingController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please add a display name";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Display Name",
                  hintText: "Enter your display name",
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        UserDataDocumentManager.instance.update(
                            displayName: displayNameTextEditingController.text,
                            imageUrl: _updatedImageUrl);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Save and Close"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}