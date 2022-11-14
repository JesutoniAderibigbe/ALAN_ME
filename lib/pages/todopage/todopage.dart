// import 'dart:async';

// import 'package:animated_background/animated_background.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:todo_app/data/database.dart';
// import 'package:todo_app/notification_service/notification_service.dart';
// import 'package:todo_app/util/dialog_box.dart';
// import 'package:todo_app/util/todo_tile.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

// class TodoPage extends StatefulWidget {
//   const TodoPage({Key? key}) : super(key: key);

//   @override
//   State<TodoPage> createState() => _TodoPageState();
// }

// class _TodoPageState extends State<TodoPage>
//     with SingleTickerProviderStateMixin {
//   AccelerometerEvent? acceleration;
//   StreamSubscription<AccelerometerEvent>? _streamSubscription;

//   int planetMotionSensitivity = 4;
//   int bgMotionSensitivity = 2;

//   //Get the details of the User
//   final user = FirebaseAuth.instance.currentUser!;

//   ParticleOptions particles = const ParticleOptions(
//       baseColor: Colors.black,
//       spawnOpacity: 0.0,
//       opacityChangeRate: 0.25,
//       minOpacity: 0.1,
//       maxOpacity: 0.4,
//       particleCount: 70,
//       spawnMaxRadius: 15.0,
//       spawnMaxSpeed: 300.0,
//       spawnMinSpeed: 300,
//       spawnMinRadius: 7.0);

//   final _myBox = Hive.box("myBox");
//   ToDoDataBase db = ToDoDataBase();

//   @override
//   void initState() {
//     if (_myBox.get("TODOLIST") == null) {
//       db.createInitialData();
//     } else {
//       db.loadData();
//     }

//     super.initState();
//     tz.initializeTimeZones();
//   }

// //text controller

//   final _controller = TextEditingController();
//   final _times = TextEditingController();
// //list of todo tasks

//   //checkbox was tapped

//   void checkBoxChanged(bool? value, int index) {
//     setState(() {
//       db.toDoList[index][1] = !db.toDoList[index][1];
//     });
//     db.updateDatabase();
//   }

//   //save New Task
//   void saveNewTask() {
//     setState(() {
//       db.toDoList.add([_controller.text, false]);
//       _controller.clear();
//     });
//     Navigator.pop(context);
//     db.updateDatabase();
//   }

//   //create a new task

//   void createNewTask() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return DialogBox(
//             controller: _controller,
//             onSave: saveNewTask,
//             onCancel: Navigator.of(context).pop,
//             //  timeController: _times,
//           );
//         });
//     NotificationService().showNote(1, _controller.text, _controller.text);
//   }

//   //delete task
//   deleteTask(int index) {
//     setState(() {
//       db.toDoList.removeAt(index);
//     });
//     db.updateDatabase();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: GestureDetector(
//           child: Icon(Icons.arrow_back, color: Colors.black),
//         ),
//         title: Text(
//           "My Reminder",
//           style: TextStyle(fontSize: 20, color: Colors.black),
//         ),
//         elevation: 0,
//         toolbarHeight: 120,
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         onPressed: createNewTask,
//         child: Icon(Icons.add),
//       ),
//       body: AnimatedBackground(
//         vsync: this,
//         behaviour: RandomParticleBehaviour(options: particles),
//         child: ListView.builder(
//           itemCount: db.toDoList.length,
//           itemBuilder: (context, index) {
//             return TodoTile(
//                 taskName: db.toDoList[index][0],
//                 taskCompleted: db.toDoList[index][1],
//                 onChanged: (value) => checkBoxChanged(value, index),
//                 deleteFunction: (context) => deleteTask(index));
//           },
//         ),
//       ),
//     );
//   }
// }
