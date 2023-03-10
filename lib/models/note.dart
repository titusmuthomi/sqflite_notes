import 'package:flutter/material.dart';

class Note {
  final int noteId;
  final String title;
  final String body;
  final DateTime time;

  Note({
    required this.noteId,
    required this.title,
    required this.body,
    required this.time,
  });
}

List<Note> notes = [
  Note(
      noteId: 0,
      title: "Learn Flutter",
      body: "Flutter is the best mobile and front end framework",
      time: DateTime.now()),
  Note(
      noteId: 1,
      title: "Laravel",
      body: "Laravel is the best backend Framework for freelancers",
      time: DateTime.now().toLocal()),
  Note(
      noteId: 2,
      title: "Learn Flutter",
      body: "Flutter is the best mobile and front end framework",
      time: DateTime.utc(2022)),
];
