import 'package:flutter/material.dart';
import 'package:notes_client/notes_client.dart';
import 'package:notes_flutter/main.dart';
import 'package:notes_flutter/widgets/loading_screen.dart';
import 'package:notes_flutter/widgets/note_dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Note>? _notes;
  Exception? _connectionException;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: _notes == null
            ? LoadingScreen(
                exception: _connectionException,
                onTryAgain: _loadNotes,
              )
            : ListView.builder(
                itemCount: _notes!.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                      title: Text(_notes![index].text),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          var note = _notes![index];

                          setState(() {
                            _notes!.remove(note);
                          });

                          _deleteNote(note);
                        },
                      ),
                      onTap: () {
                        showNoteDialog(
                          context: context,
                          text: _notes![index].text,
                          onSaved: (text) {
                            var note = Note(
                              text: text,
                            );

                            _updateNote(_notes![index], note);
                          },
                        );
                      });
                }),
              ),
      ),
      floatingActionButton: Container(
        child: _notes == null
            ? null
            : FloatingActionButton(
                onPressed: () {
                  showNoteDialog(
                    context: context,
                    onSaved: (text) {
                      var note = Note(
                        text: text,
                      );
                      _notes!.add(note);

                      _createNote(note);
                    },
                  );
                },
                child: const Icon(Icons.add),
              ),
      ),
    );
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await client.notes.getAllNotes();
      setState(() {
        _notes = notes;
      });
    } catch (e) {
      _connectionFailed(e);
    }
  }

  void _connectionFailed(dynamic exception) {
    setState(() {
      _notes = null;
      _connectionException = exception;
    });
  }

  Future<void> _createNote(Note note) async {
    try {
      await client.notes.createNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _deleteNote(Note note) async {
    try {
      await client.notes.deleteNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _updateNote(Note noteOld, Note noteNew) async {
    try {
      await client.notes.updateNote(noteOld, noteNew);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }
}
