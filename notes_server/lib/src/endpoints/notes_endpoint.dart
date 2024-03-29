import 'package:serverpod/server.dart';

import '../generated/protocol.dart';

class NotesEndpoint extends Endpoint {
  // Endpoint implementation goes here
  Future<void> example(Session session) async {
    // Endpoint implementation goes here
  }

  Future<void> createNote(Session session, Note note) async {
    await Note.db.insertRow(session, note);
  }

  Future<void> deleteNote(Session session, Note note) async {
    await Note.db.deleteRow(session, note);
  }

  Future<List<Note>> getAllNotes(Session session) async {
    // By ordering by the id column, we always get the notes in the same order
    // and not in the order they were updated.
    return await Note.db.find(
      session,
      orderBy: (t) => t.id,
    );
  }

  Future<void> updateNote(Session session, Note noteOld, Note noteNew) async {
    var noteFind = await Note.db.findFirstRow(
      session,
      where: (t) => t.text.equals(noteOld.text),
    );

    if (noteFind != null) {
      noteFind.text = noteNew.text;

      await Note.db.updateRow(session, noteFind);
    }
  }
}
