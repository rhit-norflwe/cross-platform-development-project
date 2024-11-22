import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notesbysubject/manager/auth_manager.dart';
import 'package:notesbysubject/models/note.dart';


class NotesCollectionManager {
  final CollectionReference _ref;

  static final NotesCollectionManager instance =
      NotesCollectionManager._privateConstructor();

  NotesCollectionManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kNotesCollectionPath);

  Future<void> add({
    required String title,
    required String note,
    required String subject,
  }) {
    return _ref.add({
      kNoteAuthorUid: AuthManager.instance.uid,
      kNoteTitle: title,
      kNoteNote: note,
      kNoteSubject: subject,
      kNoteLastTouched: Timestamp.now(),
    }).then((DocumentReference docRef) {
      print("The add is finished, the doc id was ${docRef.id}");
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  Query<Note> get allNotesQuery =>
      _ref.orderBy(kNoteLastTouched, descending: true).withConverter(
            fromFirestore: (documentSnapshot, _) => Note.from(documentSnapshot),
            toFirestore: (note, _) => note.toJsonMap(),
          );

  Query<Note> get onlyMyNotesQuery =>
      allNotesQuery.where(kNoteAuthorUid, isEqualTo: AuthManager.instance.uid);
}
