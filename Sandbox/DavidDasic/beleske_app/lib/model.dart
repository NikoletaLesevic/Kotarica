class Note {
  String title;
  Note({
    this.title
  });
  factory Note.fromJson(Map < String, dynamic > json) => Note(
      title: json['title']);
  Map < String, dynamic > toJson() => {
    'title': title
  };
}
