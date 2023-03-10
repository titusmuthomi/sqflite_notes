import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteCard extends StatelessWidget {
  Note note = notes[0];
  NoteCard({super.key, required Note});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: ListTile(
        minVerticalPadding: 10,
        title: Text(
          note.title,
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w900),
        ),
        subtitle: Text(note.body,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  //TODO: Edit Note
                },
                icon: const Icon(Icons.edit)),
          ],
        ),
        trailing: Text(note.time.toString()),
      ),
    );
  }
}
