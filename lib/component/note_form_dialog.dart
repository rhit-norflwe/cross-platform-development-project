import 'package:flutter/material.dart';
import 'package:notesbysubject/manager/note_document_manager.dart';
import 'package:notesbysubject/manager/notes_collection_manager.dart';

const List<String> list = <String>[
  'English',
  'History',
  'Math',
  'Science',
];
String dropdownValue = list.first;

class NoteFormDialog extends StatelessWidget {
  final TextEditingController noteTextEditingController;
  final TextEditingController titleTextEditingController;
  final bool alreadyExists;

  const NoteFormDialog({
    super.key,
    required this.noteTextEditingController,
    required this.titleTextEditingController,
    required this.alreadyExists,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Note"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleTextEditingController,
            decoration: const InputDecoration(
              labelText: "Title",
              border: UnderlineInputBorder(),
            ),
          ),
          TextField(
            controller: noteTextEditingController,
            decoration: const InputDecoration(
              labelText: "Body",
              border: UnderlineInputBorder(),
            ),
          ),
          const Row(
            children: [
              Text("Subject:"),
              Spacer(),
              DropdownButtonExample(),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (alreadyExists) {
              NoteDocumentManager.instance.update(
                title: titleTextEditingController.text,
                note: noteTextEditingController.text,
                subject: dropdownValue,
              );
            } else {
              NotesCollectionManager.instance.add(
                title: titleTextEditingController.text,
                note: noteTextEditingController.text,
                subject: dropdownValue,
              );
            }
            Navigator.pop(context);
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
