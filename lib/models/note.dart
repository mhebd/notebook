class Note {
  String content;
  DateTime date;
  bool done;
  bool argent;

  Note({
    required this.content,
    required this.date,
    required this.done,
    required this.argent,
  });

  factory Note.fromMap(Map note) {
    return Note(
      content: note['content'],
      date: note['date'],
      done: note['done'],
      argent: note['argent'],
    );
  }

  Map toMap() {
    return {
      "content": content,
      "date": date,
      "done": done,
      "argent": argent,
    };
  }
}
