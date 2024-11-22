import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notesbysubject/models/note.dart';

class NoteDocumentManager {
  Note? latestNote;
  final CollectionReference _ref;

  static final NoteDocumentManager instance =
      NoteDocumentManager._privateConstructor();

  NoteDocumentManager._privateConstructor()
      : _ref =
            FirebaseFirestore.instance.collection(kNotesCollectionPath);

  StreamSubscription startListening({
    required String documentId,
    required Function observer,
  }) =>
      _ref.doc(documentId).snapshots().listen(
          (DocumentSnapshot documentSnapshot) {
        latestNote = Note.from(documentSnapshot);
        observer();
      }, onError: (error) {
        print("Error listening for Note $error");
      });

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  Future<void> delete() => _ref.doc(latestNote!.documentId!).delete();

  Future<void> update({
    required String title,
    required String note,
    required String subject,
  }) {
    return _ref.doc(latestNote!.documentId!).update({
      kNoteTitle: title,
      kNoteNote: note,
      kNoteSubject: subject,
      kNoteLastTouched: Timestamp.now(),
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  void restore(Note nToRestore) {
    _ref.doc(nToRestore.documentId!).set({
      kNoteTitle: nToRestore.title,
      kNoteNote: nToRestore.note,
      kNoteLastTouched: nToRestore.lastTouched,
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  void clearLatest() {
    latestNote = null;
  }

  String get title => latestNote?.title ?? "";
  String get note => latestNote?.note ?? "";
  String get subject => latestNote?.subject ?? "";
  String get authorUid => latestNote?.authorUid ?? "";
}