import 'package:flutter/material.dart';
import 'package:lets_todo/database_helper.dart';
import 'package:lets_todo/modals/task.dart';
import 'package:lets_todo/modals/todo.dart';
import 'package:lets_todo/widgits.dart';

//homepage->taskpage

class TaskPage extends StatefulWidget {
  final Task? task;

  TaskPage({this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  String _tasktitle = '';
  String _taskdescription = '';
  String _todotitle = '';
  int _taskid = 0;

  late FocusNode _titlefocus;
  late FocusNode _descriptionfocus;
  late FocusNode _todofocus;
  bool _contentvisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      _contentvisible = true;
      _tasktitle = widget.task!.title.toString();
      _taskdescription = widget.task!.description.toString();
      _taskid = widget.task!.id!.toInt();
    }
    _titlefocus = FocusNode();
    _descriptionfocus = FocusNode();
    _todofocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _titlefocus.dispose();
    _descriptionfocus.dispose();
    _todofocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //only arrow and tasktitle
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                          ),
                        ),
                      ),
                      //tasktitle
                      Expanded(
                        child: TextField(
                          focusNode: _titlefocus,
                          onSubmitted: (value) async {
                            // print("title '$value'");
                            //when field is not empty
                            if (value != "") {
                              if (widget.task == null) {
                                Task _newTask = Task(title: '$value');
                                _taskid = await _dbHelper.insertTask(_newTask);
                                setState(
                                  () {
                                    _contentvisible = true;
                                    _tasktitle = value;
                                  },
                                );
                                //print("taskid '$_taskid'");
                              } else {
                                _dbHelper.updateTaskTitle(_taskid, value);
                                print('$_taskid , $value');
                              }
                              _descriptionfocus.requestFocus();
                            }
                          },
                          controller: TextEditingController()
                            ..text = _tasktitle,
                          decoration: InputDecoration(
                            hintText: 'Enter the task title....',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
                //descriptions
                Visibility(
                  visible: _contentvisible,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      focusNode: _descriptionfocus,
                      onSubmitted: (value) async {
                        //print("$value");
                        if (value != "") {
                          if (_taskid != 0) {
                            await _dbHelper.updateDescription(_taskid, value);
                            _taskdescription = value;
                          }
                        }

                        _todofocus.requestFocus();
                      },
                      controller: TextEditingController()
                        ..text = _taskdescription,
                      decoration: InputDecoration(
                        hintText: 'Enter description for the task .....',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                //future builder
                Visibility(
                  visible: _contentvisible,
                  child: FutureBuilder(
                    initialData: [],
                    future: _dbHelper.getTodo(_taskid),
                    builder: ((context, AsyncSnapshot<dynamic> snapshot) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (snapshot.data[index].isDone == 0) {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data[index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data[index].id, 0);
                                  }
                                  setState(() {});
                                },
                                child: TodoWidgit(
                                  text: snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            }),
                      );
                    }),
                  ),
                ),

                //icon+textfield
                Visibility(
                  visible: _contentvisible,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        //for icon box
                        Container(
                          height: 20,
                          width: 20,
                          margin: EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.purple, width: 1.5),
                              color: Colors.transparent),
                          // child: Icon(
                          //   Icons.check_box,
                          //   color: Colors.blue,
                          // ),
                        ),
                        //textfield
                        Expanded(
                          child: TextField(
                            focusNode: _todofocus,
                            onSubmitted: (value) async {
                              if (value != "") {
                                //if (widget.task != null) {
                                if (_taskid != 0) {
                                  Todo _newTodo = Todo(
                                    title: value,
                                    isDone: 0,
                                    //taskid: widget.task!.id,
                                    taskid: _taskid,
                                  );
                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {});
                                  //print('todo created');
                                }
                                _todofocus.requestFocus();
                              } else {
                                print("Task doesn't created");
                              }
                            },
                            controller: TextEditingController()
                              ..text = _todotitle,
                            decoration: InputDecoration(
                              hintText: 'Enter todo item....',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _contentvisible,
              child: Positioned(
                bottom: 20,
                right: 20,
                child: InkWell(
                  onTap: () async {
                    if (_taskid != 0) {
                      await _dbHelper.DeleteTask(_taskid);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Colors.red,
                        Color.fromARGB(255, 145, 152, 223),
                      ], begin: Alignment.topCenter),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 30,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
