import 'package:flutter/material.dart';

class Taskcard extends StatelessWidget {
  String? tasktitle;
  String? desc;
  Taskcard({this.tasktitle, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tasktitle ?? 'No title given',
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 22),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              desc ?? 'no decription added',
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}

class TodoWidgit extends StatelessWidget {
  final bool isDone;
  final String? text;
  TodoWidgit({this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Container(
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
                border: isDone
                    ? null
                    : Border.all(color: Colors.blueGrey, width: 1)),
            child: Icon(
              Icons.check_box,
              color: isDone ? Colors.blue : Colors.transparent,
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Text(
              text ?? '(Unnamed Todo)',
              style: TextStyle(
                  color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
                  fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
