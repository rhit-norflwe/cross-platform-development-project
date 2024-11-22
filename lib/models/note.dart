import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notesbysubject/models/firestore_model_utils.dart';

const kNotesCollectionPath = "Notes";
const kNoteAuthorUid = "authorUid";
const kNoteTitle = "title";
const kNoteNote = "note";
const kNoteSubject = "subject";
const kNoteLastTouched = "lastTouched";

class Note {
  String? documentId;
  String authorUid;
  String title;
  String note;
  String subject;
  Timestamp lastTouched;

  Note({
    this.documentId,
    required this.authorUid,
    required this.title,
    required this.note,
    required this.subject,
    required this.lastTouched,
  });

  Note.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          authorUid:
              FirestoreModelUtils.getStringField(doc, kNoteAuthorUid),
          title: FirestoreModelUtils.getStringField(doc, kNoteTitle),
          note: FirestoreModelUtils.getStringField(doc, kNoteNote),
          subject: FirestoreModelUtils.getStringField(doc, kNoteSubject),
          lastTouched: FirestoreModelUtils.getTimestampField(
              doc, kNoteLastTouched),
        );

  Map<String, Object?> toJsonMap() => {
        kNoteAuthorUid: authorUid,
        kNoteTitle: title,
        kNoteNote: note,
        kNoteSubject: subject,
        kNoteLastTouched: lastTouched,
      };

  @override
  String toString() {
    return "Title: $title Subject: $subject Note: $note";
  }
}