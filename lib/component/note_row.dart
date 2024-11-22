import 'package:flutter/material.dart';
import 'package:notesbysubject/models/note.dart';

class NoteRow extends StatelessWidget {
  final Note note;
  final void Function() onClick;

  const NoteRow({
    super.key,
    required this.note,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onClick,
      leading: const Icon(Icons.note),
      title: Text(
        note.title,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        note.subject,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}