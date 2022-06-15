import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lets_todo/database_helper.dart';
import 'package:lets_todo/pages/task_page.dart';
import 'package:lets_todo/widgits.dart';

//mainpage->homepage

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    DatabaseHelper _db = DatabaseHelper();
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Image(
                          image: AssetImage('assets/images/loading.png'))),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: NoGlowBehavior(),
                      child: FutureBuilder<dynamic>(
                        initialData: [],
                        future: _db.getTasks(),
                        builder: ((context, AsyncSnapshot<dynamic> snapshot) {
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TaskPage(
                                                task: snapshot.data[index],
                                              ))).then((value) {
                                    setState(() {});
                                  }),
                                  child: Taskcard(
                                    tasktitle: snapshot.data[index].title,
                                    desc: snapshot.data[index].description,
                                  ),
                                );
                              });
                        }),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskPage(
                        task: null,
                      ),
                      // directing to next page => taskpage
                    ),
                  ).then((value) {
                    setState(() {});
                  }),
                  child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.blue,
                          Color.fromARGB(255, 145, 152, 223)
                        ], begin: Alignment.topCenter),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30.0,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
