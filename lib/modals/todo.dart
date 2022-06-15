class Todo {
  int? id;
  String? title;
  int? taskid;
  int? isDone;

  Todo({this.id, this.title, this.taskid, this.isDone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'taskid': taskid,
      'isDone': isDone,
    };
  }
}
