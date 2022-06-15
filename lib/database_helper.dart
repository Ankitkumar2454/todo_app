import 'package:lets_todo/modals/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'modals/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
        await db.execute(
            'CREATE TABLE todo(id INTEGER PRIMARY KEY, title TEXT, taskid INTEGER, isDone INTEGER)');

        return;
        //return db;
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskid = 0;
    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskid = value;
    });
    return taskid;
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("update tasks set title ='$title' where id='$id'");
  }

  Future<void> updateDescription(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate(
        "update tasks set description ='$description' where id='$id'");
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
        id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        description: taskMap[index]['description'],
      );
    });
  }

  Future<List<Todo>> getTodo(int taskid) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery('Select * from todo where taskid=$taskid');
    return List.generate(todoMap.length, (index) {
      return Todo(
        id: todoMap[index]['id'],
        title: todoMap[index]['title'],
        taskid: todoMap[index]['taskid'],
        isDone: todoMap[index]['isDone'],
      );
    });
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate("update todo set isDone ='$isDone' where id='$id'");
  }

  Future<void> DeleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("delete from tasks where id='$id'");
    await _db.rawDelete("delete from todo where taskid='$id'");
  }
}
