import 'package:flutter/material.dart';
import 'package:tito_notes_sqflite/database/notedbhelper.dart';

import '../models/note.dart';
import '../widgets/card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  List<Map<String, dynamic>> _journals = [];
  //? snap;
  int? index;

  bool _isloading = true;
  insertdatabase(title, description) {
    NoteDbHelper.instance.insert({
      NoteDbHelper.colTitle: title,
      NoteDbHelper.colDescription: description,
      NoteDbHelper.colCreatedAt: DateTime.now().toString()
    });
  }

  updatedatabase(index, title, description) {
    NoteDbHelper.instance.update({
      NoteDbHelper.colId: snap.data![index][NoteDbHelper.colId],
      NoteDbHelper.colTitle: title,
      NoteDbHelper.colDescription: description,
      NoteDbHelper.colCreatedAt: DateTime.now().toString()
    });
  }

  deletedatabase(snap, index) {
    NoteDbHelper.instance.delete(snap.data![index][NoteDbHelper.colId]);
  }

  @override
  Widget build(BuildContext context) {
    AsyncSnapshot<List<Map<String, dynamic>>>? snap;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note APP'),
      ),
      body: FutureBuilder(
          future: NoteDbHelper.instance.queryAll(),
          builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snap) {
            if (snap.hasData) {
              return ListView.builder(
                  itemCount: snap.data!.length,
                  itemBuilder: (BuildContext context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        deletedatabase(snap, index);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                      ),
                      child: Card(
                        color: Colors.blue,
                        margin: const EdgeInsets.all(15),
                        child: ListTile(
                          title: Text(
                            snap.data![index][NoteDbHelper.colTitle],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                              snap.data![index][NoteDbHelper.colDescription],
                              style: TextStyle(color: Colors.white)),
                          trailing: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _showForm(
                                        snap.data![index][NoteDbHelper.colId],
                                        snap.data![index]
                                            [NoteDbHelper.colDescription],
                                        snap.data![index]
                                            [NoteDbHelper.colTitle]),
                                    icon: const Icon(Icons.edit),
                                    color: Colors.white,
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteItem(
                                        snap.data![index][NoteDbHelper.colId]),
                                    icon: const Icon(Icons.delete),
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
            //
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showForm();
          },
          label: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.add),
              Text("Add Note"),
            ],
          )),
    );
  }

  Future<void> _addItem() async {
    insertdatabase(_titleController.text, _bodyController.text);
    // await SQLHelper.createnote(_titleController.text, _bodyController.text);
    // _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    updatedatabase(index, _titleController.text, _bodyController.text);
    // await SQLHelper.updateNote(id, _titleController.text, _bodyController.text);
    // _refreshJournals();
  }

  void _deleteItem(int id) async {
    // await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.blue,
        content: Text(
          'Successfully \n deleted a Journal',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    // _refreshJournals();
  }

  void _showForm(int? id, String description, String title) async {
    if (id != null) {
      title = _titleController.text;
      description = _bodyController.text;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right:
                15, //this will prevent the soft keyboard from covering text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(hintText: 'Details'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addItem();
                  }
                  if (id != null) {
                    await _updateItem(id);
                  }

                  //clear textfields
                  _titleController.clear();
                  _bodyController.clear();

                  //close bottom sheet
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(id == null ? 'Create New' : 'Update'))
          ],
        ),
      ),
    );
  }
}
