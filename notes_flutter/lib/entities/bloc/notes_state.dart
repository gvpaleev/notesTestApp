part of 'notes_bloc.dart';

@immutable
sealed class NotesState {
  final List<Note>? notes;
  final Exception? exception;

  // var exception;

  const NotesState({required this.notes, required this.exception});
}

final class NotesInitial extends NotesState {
  const NotesInitial() : super(notes: null, exception: null);
}

final class NewNotesState extends NotesState {
  const NewNotesState({required super.notes, super.exception});
}

final class ErrorConnectState extends NotesState {
  ErrorConnectState({required super.exception}) : super(notes: null);
}
