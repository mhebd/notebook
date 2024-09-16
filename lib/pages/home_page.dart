import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notebook/models/note.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();

  late Box _notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        titleSpacing: 2,
        title: const Text(
          'NoteBook',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _fetchAndShowNotes(),
      ),
      floatingActionButton: _addNoteButton(),
    );
  }

  // Fetch all note from hive box
  Widget _fetchAndShowNotes() {
    return FutureBuilder(
        future: Hive.openBox('notes'),
        builder: (BuildContext context, AsyncSnapshot snapShot) {
          if (snapShot.hasData) {
            _notes = snapShot.data;
            return _notesListView();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  // Show note list view
  Widget _notesListView() {
    List notes = _notes.values.toList();
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (BuildContext context, int index) {
        Note note = Note.fromMap(notes[index]);
        return GestureDetector(
          onDoubleTap: () {
            note.argent = !note.argent;
            _notes.putAt(index, note.toMap());
            setState(() {});
          },
          child: ListTile(
            onTap: () {
              note.done = !note.done;
              _notes.putAt(index, note.toMap());
              setState(() {});
            },
            onLongPress: () => _deleteNoteModal(index),
            tileColor: note.done
                ? Colors.lightGreen
                : note.argent
                    ? Colors.redAccent
                    : null,
            title: Text(
              note.content,
              style: TextStyle(
                decoration: note.done ? TextDecoration.lineThrough : null,
                color: note.argent || note.done ? Colors.white : null,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              DateFormat('MMMM d, yyyy').format(note.date),
              style: TextStyle(
                color: note.argent || note.done ? Colors.white70 : null,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            trailing: Icon(
              note.done
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank_rounded,
              color: note.argent || note.done ? Colors.white : null,
            ),
          ),
        );
      },
    );
  }

  // Bottom add note floatingActionButton
  Widget _addNoteButton() {
    return FloatingActionButton(
      onPressed: _addNoteModal,
      backgroundColor: Colors.blueAccent,
      clipBehavior: Clip.none,
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  // Delete note modal
  void _deleteNoteModal(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          content: const Text(
              'Be aware that this action will permanently delete the note'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _notes.delete(index);
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Add note modal
  void _addNoteModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'New Note',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          clipBehavior: Clip.none,
          content: TextField(
            autofocus: true,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'What is on your mind?'),
            onSubmitted: (value) {
              var newNote = Note(
                content: value,
                date: DateTime.now(),
                done: false,
                argent: false,
              );
              _notes.add(
                newNote.toMap(),
              );
              setState(() {});
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
