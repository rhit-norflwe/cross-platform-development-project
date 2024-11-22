import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notesbysubject/manager/auth_manager.dart';
import 'package:notesbysubject/models/user_data.dart';

class UserDataDocumentManager {
  UserData? latestUserData;
  final CollectionReference _ref;

  static final UserDataDocumentManager instance =
      UserDataDocumentManager._privateConstructor();

  UserDataDocumentManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kUserDatasCollectionPath);

  StreamSubscription startListening({
    required String documentId,
    required Function observer,
  }) =>
      _ref.doc(documentId).snapshots().listen(
          (DocumentSnapshot documentSnapshot) {
        latestUserData = UserData.from(documentSnapshot);
        observer();
      }, onError: (error) {
        print("Error listening for Note $error");
      });

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  void maybeAddNewUser() async {
    // Get the UserData for the current user
    DocumentSnapshot doc = await _ref.doc(AuthManager.instance.uid).get();
    if (!doc.exists) {
      // New user.  Make a UserData for them!
      createUserDataFromCurrentUser();
    }
  }

  void createUserDataFromCurrentUser() {
    final userDataMap = <String, Object>{};
    userDataMap[kUserDataCreated] = Timestamp.now();
    if (AuthManager.instance.hasDisplayName) {
      userDataMap[kUserDataDisplayName] = AuthManager.instance.displayName;
    }
    if (AuthManager.instance.hasPhotoUrl) {
      userDataMap[kUserDataImageUrl] = AuthManager.instance.photoUrl;
    }
    _ref.doc(AuthManager.instance.uid).set(userDataMap).catchError((err) {
      print("Error making the UserData ${err.toString()}");
    });
  }

  Future<void> update({
    required String displayName,
    String? imageUrl,
  }) {
    final updatedFields = {
      kUserDataDisplayName: displayName,
    };
    if (imageUrl != null) {
      updatedFields[kUserDataImageUrl] = imageUrl;
    }
    return _ref
        .doc(latestUserData!.documentId!)
        .update(updatedFields)
        .catchError((error) {
      print("There was an error: $error");
    });
  }

  bool get hasDisplayName =>
      latestUserData != null && latestUserData!.displayName.isNotEmpty;
  bool get hasImageUrl =>
      latestUserData != null && latestUserData!.imageUrl.isNotEmpty;

  String get displayName => latestUserData?.displayName ?? "";
  String get imageUrl => latestUserData?.imageUrl ?? "";

  void clearLatest() {
    latestUserData = null;
  }
}