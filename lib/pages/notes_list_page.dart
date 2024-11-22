import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesbysubject/component/list_page_drawer.dart';
import 'package:notesbysubject/component/note_form_dialog.dart';
import 'package:notesbysubject/component/note_row.dart';
import 'package:notesbysubject/manager/auth_manager.dart';
import 'package:notesbysubject/manager/notes_collection_manager.dart';
import 'package:notesbysubject/manager/user_data_document_manager.dart';
import 'package:notesbysubject/models/note.dart';
import 'package:notesbysubject/pages/login_front_page.dart';
import 'package:notesbysubject/pages/note_detail_page.dart';
import 'package:notesbysubject/pages/profile_page.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  final titleTextEditingController = TextEditingController();
  final noteTextEditingController = TextEditingController();
  UniqueKey? _loginObserverKey;
  UniqueKey? _logoutObserverKey;
  bool _isShowingAllTitles = true;
  String specificSubjectShowing = "English";

  @override
  void initState() {
    super.initState();
    _loginObserverKey = AuthManager.instance.addLoginObserver(() {
      UserDataDocumentManager.instance.maybeAddNewUser();
      setState(() {});
    });
    _logoutObserverKey = AuthManager.instance.addLogoutObserver(() {
      setState(() {
        _isShowingAllTitles = true;
      });
    });
  }

  @override
  void dispose() {
    titleTextEditingController.dispose();
    noteTextEditingController.dispose();
    AuthManager.instance.removeObserver(_loginObserverKey);
    AuthManager.instance.removeObserver(_logoutObserverKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[];
    if (!AuthManager.instance.isSignedin) {
      actions = [
        IconButton(
          tooltip: "Log in",
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoginFrontPage(),
              ),
            );
            setState(() {});
          },
          icon: const Icon(Icons.login),
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Notes"),
        actions: actions,
      ),
      body: FirestoreListView(
        query: _isShowingAllTitles
            ? NotesCollectionManager.instance.allNotesQuery
            : NotesCollectionManager.instance.onlyMyNotesQuery,
        itemBuilder: (context, snapshot) {
          final Note n = snapshot.data();
          return NoteRow(
            note: n,
            onClick: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      NoteDetailPage(documentId: n.documentId!),
                ),
              );
            },
          );
        },
      ),
      drawer: AuthManager.instance.isSignedin
          ? ListPageDrawer(
              editProfileCallback: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
              showOnlyMineCallback: () {
                setState(() {
                  _isShowingAllTitles = false;
                });
              },
              showAllCallback: () {
                setState(() {
                  _isShowingAllTitles = true;
                });
              },
            )
          : null,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Notes"),
        onPressed: () {
          if (AuthManager.instance.isSignedin) {
            showCreateTitleDialog();
          } else {
            showLoginRequestDialog();
          }
        },
        tooltip: 'Increment',
        icon: const Icon(Icons.note),
      ),
    );
  }

  void showLoginRequestDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Login Required"),
            content: const Text(
                "You must be signed in to add a note.  Would you like to sign in now?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginFrontPage(),
                    ),
                  );
                  setState(() {});
                },
                child: const Text("Go to Sign in Page"),
              ),
            ],
          );
        });
  }

  void showCreateTitleDialog() {
    titleTextEditingController.text = "";
    noteTextEditingController.text = "";
    showDialog(
      context: context,
      builder: (context) => NoteFormDialog(
        titleTextEditingController: titleTextEditingController,
        noteTextEditingController: noteTextEditingController,
        alreadyExists: false,
      ),
    );
  }
}
