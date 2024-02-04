part of 'notes_bloc.dart';

@immutable
sealed class NotesState {
  final List<Note>? notes;

  const NotesState({required this.notes});
}

final class NotesInitial extends NotesState {
  const NotesInitial() : super(notes: null);
}

final class NewNotesState extends NotesState {
  const NewNotesState({required super.notes});
}

final class ErrorConnectState extends NotesState {
  var exception;
  ErrorConnectState({required dynamic this.exception}) : super(notes: null);
}
