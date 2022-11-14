import 'dart:async';
import 'dart:math';

import 'package:animated_background/animated_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/api/google_sheets_api.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/notification_service/notification_service.dart';
import 'package:todo_app/pages/login_page.dart';
import 'package:todo_app/pages/todopage/button.dart';
import 'package:todo_app/pages/todopage/list_of_todo.dart';
import 'package:todo_app/pages/todopage/loading_circle.dart';
import 'package:todo_app/pages/todopage/notes_grid.dart';
import 'package:todo_app/pages/todopage/signuppage.dart';
import 'package:todo_app/pages/todopage/textbox.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/my_button.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:todo_app/util/todo_tile.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TipPage extends StatefulWidget {
  const TipPage({Key? key}) : super(key: key);

  @override
  State<TipPage> createState() => _TipPageState();
}

class _TipPageState extends State<TipPage> with SingleTickerProviderStateMixin {
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController _punmber = TextEditingController();

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _phonectics = TextEditingController();
  final TextEditingController _time = TextEditingController();

  //getting the User details
  final user = FirebaseAuth.instance.currentUser!;

  final _myBox = Hive.box("myBox");
  ToDoDataBase db = ToDoDataBase();

  final _times = TextEditingController();

  int _counter = 0;

  ParticleOptions particles = ParticleOptions(
      baseColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      spawnOpacity: 0.0,
      opacityChangeRate: 0.25,
      minOpacity: 0.1,
      maxOpacity: 0.4,
      particleCount: 70,
      spawnMaxRadius: 15.0,
      spawnMaxSpeed: 300.0,
      spawnMinSpeed: 300,
      spawnMinRadius: 7.0);

  MyHomePageState() {
    /// Init Alan Button with project key from Alan Studio
    AlanVoice.addButton(
        "e1014b6ce51afefa611c4c32be911a5b2e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    /// Handle commands from Alan Studio
    AlanVoice.onCommand.add((command) {
      _handleCommand(command.data);
    });
  }

  createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            SubTask: _phonectics,
            time: _time,
            onSave: saveNewTask,
            onCancel: Navigator.of(context).pop,
            //timeController: _times,
          );
        });
  }

  @override
  void initState() {
    super.initState();
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    _controller.addListener(() => setState(() {}));
    MyHomePageState();
    tz.initializeTimeZones();
    ParticleOptions();
  }

  void _post() {
    db.toDoList.add([_controller.text, false]);

    _controller.clear();
    db.updateDatabase();

    setState(() {});
  }

  void _delete() {
    db.toDoList.remove([_controller.text, false]);
    _controller.clear();
    db.updateDatabase();

    setState(() {});
  }

  // void startLoading() {
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (GoogleSheetsApi.loading == false) {
  //       setState(() {});
  //       timer.cancel();
  //     }
  //   });
  // }

  deleteTask(int index) {
    setState(() {
      var item = db.toDoList.removeAt(index);

      final snackBar = SnackBar(
        duration: Duration(seconds: 10, milliseconds: 10),
        backgroundColor: Colors.purple,
        content: Text('$item deleted'),
        action: SnackBarAction(
          textColor: Colors.black,
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
            setState(() {
              db.toDoList.insert(index, item);
            });
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    db.updateDatabase();
  }

  void saveNewTask() {
    setState(() {
      var items = db.toDoList.add([_controller.text, false]);
      _controller.clear();
      NotificationService().showNote(1, "TodoApp",
          "Hello ${user.displayName!}, You told me to remind you about gg");
    });

    Navigator.pop(context);
    db.updateDatabase();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDatabase();
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch (command['command']) {
      case "remind": // reminder
        _post();
        break;
      case 'forward':
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
        break;
      case 'back':
        Navigator.push(context, MaterialPageRoute(builder: (_) => TipPage()));
        break;
      case 'anything':
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
        CircularProgressIndicator();

        // Navigator.push(context, MaterialPageRoute(builder: (_) => TipPage()));

        break;

      case 'me':
        Navigator.push(context, MaterialPageRoute(builder: (_) => TipPage()));
        // Navigator.push(context, MaterialPageRoute(builder: (_) => TipPage()));

        break;

      case 'food':
        break;

      case 'date':
        break;

      case 'SignUp':
        Navigator.push(context, MaterialPageRoute(builder: (_) => SignUp()));

        break;

      case "getAlan": //how is Alan doing?
        break;

      // case 'getData':
      //   _controller.text = command['text'];
      //   _post();

      //   break;

      case "getName": //name formfield
        name.text = command['text'];
        break;

      case "getAddress": //address formfield
        address.text = command['text'];
        break;

      case "getPhone": // phone number textfield
        _punmber.text = command['text'];
        break;

      case "getDelete":
        _delete();
        break;

      //translate languages
      // case "getLangauge":
      //   break;

      case "getPlans": // post a note
        _controller.text = command['text'];
        _post();

        break;

      case "getDelete":
        _controller.text = command['text'];
        _delete();

        break;

      default:
        debugPrint(
          'Unknown command',
        );
        print('Unknown Command');
    }
  }

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    //start loading until data arrives

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: createNewTask,
        // onPressed: () {
        //   showModalBottomSheet(
        //       context: context,
        //       builder: (BuildContext context) {
        //         return Container(
        //           height: 200,
        //           child: Center(
        //             child: Column(
        //               children: [
        //                 Container(
        //                   color: Colors.white,
        //                   child: Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: TextField(
        //                       controller: _controller,
        //                       decoration: InputDecoration(
        //                           hintText: "enter...",
        //                           border: OutlineInputBorder(),
        //                           suffixIcon: InkWell(
        //                             onLongPress: () {
        //                               _controller.clear();
        //                             },
        //                             child: Icon(
        //                               Icons.clear,
        //                             ),
        //                           )),
        //                     ),
        //                   ),
        //                 ),
        //                 Container(
        //                   color: Colors.white,
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Padding(
        //                         padding: const EdgeInsets.all(15.0),
        //                         child: Text("@GokuDeveloper"),
        //                       ),
        //                       MyPadding(
        //                         text: 'P O S T',
        //                         function: _post,
        //                       )
        //                     ],
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         );
        //       });
        // },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          "P O S T  A  N O T E",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedBackground(
          vsync: this,
          behaviour: RandomParticleBehaviour(options: particles),
          child: ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return TodoTile(
                    taskName: db.toDoList[index][0],
                    subTask: db.toDoList[index][0],
                    taskCompleted: db.toDoList[index][1],
                    onChanged: (value) => checkBoxChanged(value, index),
                    deleteFunction: (context) => deleteTask(index));
              })
          // ListView.builder(
          //   itemCount: db.toDoList.length,
          //   itemBuilder: (context, iindex) {
          //     return TodoTile(
          //         taskName: db.toDoList[index][0],
          //         taskCompleted: db.toDoList[index][1],
          //         onChanged: (value) => checkBoxChanged(value, index),
          //         deleteFunction: (context) {
          //           deleteTask(index);
          //         });
          //   },
          // ),
          ),
    );
  }
}
