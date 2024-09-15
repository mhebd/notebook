import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();

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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _notesListView(),
      ),
      floatingActionButton: _addNoteButton(),
    );
  }

  // Show note list view
  Widget _notesListView() {
    return ListView(
      children: [
        ListTile(
          onTap: () {},
          title: const Text('Buy some cloth.'),
          subtitle: Text(DateTime.now().toString()),
          trailing: const Icon(Icons.check_box_outline_blank_rounded),
        )
      ],
    );
  }

  // Bottom add note floatingActionButton
  Widget _addNoteButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.blueAccent,
      clipBehavior: Clip.none,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
