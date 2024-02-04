import 'package:flutter/material.dart';
import 'package:notes_client/notes_client.dart';
import 'package:notes_flutter/entities/bloc/notes_bloc.dart';
import 'package:notes_flutter/widgets/loading_screen.dart';

import 'package:notes_flutter/widgets/note_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotesBloc>(
      create: (context) => NotesBloc(),
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Container(
              child: state.notes == null
                  ? LoadingScreen(
                      exception: state.exception,
                      onTryAgain: () {
                        (context.read<NotesBloc>()).add(LoadNoteEvent());
                      })
                  : ListView.builder(
                      itemCount: state.notes!.length,
                      itemBuilder: ((context, index) {
                        return ListTile(
                            title: Text(state.notes![index].text),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                var note = state.notes![index];
                                context
                                    .read<NotesBloc>()
                                    .add(DeleteNoteEvent(note: note));
                              },
                            ),
                            onTap: () {
                              showNoteDialog(
                                context: context,
                                text: state.notes![index].text,
                                onSaved: (text) {
                                  var note = Note(
                                    text: text,
                                  );
                                  context.read<NotesBloc>().add(UpdateNoteEvent(
                                      noteOld: state.notes![index],
                                      noteNew: note));
                                },
                              );
                            });
                      }),
                    ),
            ),
            floatingActionButton: Container(
              child: state.notes == null
                  ? null
                  : FloatingActionButton(
                      onPressed: () {
                        showNoteDialog(
                          context: context,
                          onSaved: (text) {
                            var note = Note(
                              text: text,
                            );
                            context
                                .read<NotesBloc>()
                                .add(CreateNoteEvent(note: note));
                          },
                        );
                      },
                      child: const Icon(Icons.add),
                    ),
            ),
          );
        },
      ),
    );
  }
}
