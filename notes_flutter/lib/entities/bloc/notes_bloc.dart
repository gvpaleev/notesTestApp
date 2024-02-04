import 'package:bloc/bloc.dart';
import 'package:flutter/physics.dart';
import 'package:meta/meta.dart';
import 'package:notes_client/notes_client.dart';
import 'package:notes_flutter/main.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial()) {
    // on<NotesEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
    on<LoadNoteEvent>((event, emit) async {
      try {
        final notes = await client.notes.getAllNotes();
        emit(NewNotesState(notes: notes));
      } catch (e) {
        add(ConnectionFailedEvent(exception: e as Exception));
      }
    });
    on<CreateNoteEvent>((event, emit) async {
      try {
        await client.notes.createNote(event.note);
        add(LoadNoteEvent());
        // await _loadNotes();
      } catch (e) {
        add(ConnectionFailedEvent(exception: e as Exception));
      }
    });
    on<DeleteNoteEvent>((event, emit) async {
      try {
        await client.notes.deleteNote(event.note);
        add(LoadNoteEvent());
      } catch (e) {
        add(ConnectionFailedEvent(exception: e as Exception));
      }
    });
    on<UpdateNoteEvent>((event, emit) async {
      try {
        await client.notes.updateNote(event.noteOld, event.noteNew);
        add(LoadNoteEvent());
      } catch (e) {
        add(ConnectionFailedEvent(exception: e as Exception));
      }
    });
    on<ConnectionFailedEvent>((event, emit) {
      emit(ErrorConnectState(exception: event.exception));
    });
    add(LoadNoteEvent());
  }

  // void _connectionFailed(dynamic exception) {
  //   setState(() {
  //     _notes = null;
  //     _connectionException = exception;
  //   });
  // }

//   Future<void> _updateNote(Note noteOld, Note noteNew) async {
//     try {
//       await client.notes.updateNote(noteOld, noteNew);
//       await _loadNotes();
//     } catch (e) {
//       _connectionFailed(e);
//     }
//   }
  // }
}
