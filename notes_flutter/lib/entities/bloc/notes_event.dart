part of 'notes_bloc.dart';

@immutable
sealed class NotesEvent {}

class CreateNoteEvent extends NotesEvent {
  final Note note;
  CreateNoteEvent({required this.note});
}

class DeleteNoteEvent extends NotesEvent {
  final Note note;
  DeleteNoteEvent({required this.note});
}

class UpdateNoteEvent extends NotesEvent {
  final Note noteOld;
  final Note noteNew;
  UpdateNoteEvent({required this.noteOld, required this.noteNew});
}

class LoadNoteEvent extends NotesEvent {}

class ConnectionFailedEvent extends NotesEvent {
  var exception;

  ConnectionFailedEvent({required dynamic this.exception});
}

  // Future<void> _loadNotes() async {
  //   try {
  //     final notes = await client.notes.getAllNotes();
  //     setState(() {
  //       _notes = notes;
  //     });
  //   } catch (e) {
  //     _connectionFailed(e);
  //   }
  // }

  // void _connectionFailed(dynamic exception) {
  //   setState(() {
  //     _notes = null;
  //     _connectionException = exception;
  //   });
  // }

//  Future<void> _createNote(Note note) async {
//     try {
//       await client.notes.createNote(note);
//       await _loadNotes();
//     } catch (e) {
//       _connectionFailed(e);
//     }
//   }

//   Future<void> _deleteNote(Note note) async {
//     try {
//       await client.notes.deleteNote(note);
//       await _loadNotes();
//     } catch (e) {
//       _connectionFailed(e);
//     }
//   }

//   Future<void> _updateNote(Note noteOld, Note noteNew) async {
//     try {
//       await client.notes.updateNote(noteOld, noteNew);
//       await _loadNotes();
//     } catch (e) {
//       _connectionFailed(e);
//     }
//   }