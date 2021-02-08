class Comment {
  final String text;
  final List<String> attachedFiles;
  final String date;


  Comment(this.text, this.attachedFiles, this.date);

  @override
  String toString() {
    return "Comment(text: $text, attachedFiles=$attachedFiles, date=$date)";
  }

  Comment.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        attachedFiles = (json['attachedFiles'] as Iterable).map((e) => e.toString()).toList(),
        date = json['date'];

  Map<String, dynamic> toJson() => {
    'text': text,
    'attachedFiles': attachedFiles,
    'date': date,
  };

}