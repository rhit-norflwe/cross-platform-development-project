import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notesbysubject/component/author_box.dart';
import 'package:notesbysubject/component/display_card.dart';
import 'package:notesbysubject/component/note_form_dialog.dart';
import 'package:notesbysubject/manager/auth_manager.dart';
import 'package:notesbysubject/manager/note_document_manager.dart';
import 'package:notesbysubject/manager/user_data_document_manager.dart';
import 'package:notesbysubject/models/note.dart';

class NoteDetailPage extends StatefulWidget {
  final String documentId;

  const NoteDetailPage({
    super.key,
    required this.documentId,
  });

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final titleTextEditingController = TextEditingController();
  final noteTextEditingController = TextEditingController();
  StreamSubscription? noteSubscription;
  StreamSubscription? userDataSubscription;

  @override
  void initState() {
    super.initState();

    NoteDocumentManager.instance.clearLatest();
    UserDataDocumentManager.instance.clearLatest();

    noteSubscription = NoteDocumentManager.instance.startListening(
      documentId: widget.documentId,
      observer: () {
        if (NoteDocumentManager.instance.authorUid.isNotEmpty) {
          UserDataDocumentManager.instance.stopListening(userDataSubscription);
          userDataSubscription =
              UserDataDocumentManager.instance.startListening(
            documentId: NoteDocumentManager.instance.authorUid,
            observer: () {
              setState(() {});
            },
          );
        }
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    titleTextEditingController.dispose();
    noteTextEditingController.dispose();
    NoteDocumentManager.instance.stopListening(noteSubscription);
    UserDataDocumentManager.instance.stopListening(userDataSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "Display the author information for: ${UserDataDocumentManager.instance.displayName}");
    print(
        "and display the picture at ${UserDataDocumentManager.instance.imageUrl}");
    var actions = <Widget>[];

    if (NoteDocumentManager.instance.latestNote != null &&
        AuthManager.instance.uid.isNotEmpty &&
        AuthManager.instance.uid == NoteDocumentManager.instance.authorUid) {
      actions = <Widget>[
        IconButton(
          onPressed: () {
            showEditTitleDialog();
          },
          tooltip: "Edit",
          icon: const Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () {
            Note deletedN = NoteDocumentManager.instance.latestNote!;
            NoteDocumentManager.instance.delete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Title deleted"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    NoteDocumentManager.instance.restore(deletedN);
                  },
                ),
              ),
            );

            Navigator.of(context).pop();
          },
          tooltip: "Delete",
          icon: const Icon(Icons.delete),
        ),
      ];
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: actions,
      ),
      backgroundColor: Colors.grey,
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            DisplayCard(
              labelText: NoteDocumentManager.instance.title,
              displayText: NoteDocumentManager.instance.note,
              subjectText: "(${NoteDocumentManager.instance.subject})",
            ),
            const Spacer(),
            AuthorBox(
              imageUrl: UserDataDocumentManager.instance.imageUrl,
              name: UserDataDocumentManager.instance.displayName,
            ),
          ],
        ),
      ),
    );
  }

  void showEditTitleDialog() {
    titleTextEditingController.text = NoteDocumentManager.instance.title;
    noteTextEditingController.text = NoteDocumentManager.instance.note;
    showDialog(
      context: context,
      builder: (context) => NoteFormDialog(
        titleTextEditingController: titleTextEditingController,
        noteTextEditingController: noteTextEditingController,
        alreadyExists: true,
      ),
    );
  }
}
