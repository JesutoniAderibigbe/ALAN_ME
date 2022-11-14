import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/util/my_button.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:animated_background/animated_background.dart';

class DialogBox extends StatefulWidget {
  final controller;
  final sub;
  final SubTask;
  final time;
  final timeController;
  VoidCallback onSave;
  VoidCallback onCancel;
  DialogBox(
      {Key? key,
      required this.controller,
      required this.onSave,
      required this.onCancel,
      this.timeController,
      required this.SubTask,
      this.time,
      this.sub})
      : super(key: key);

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox>
    with SingleTickerProviderStateMixin {
  int _counter = 0;

  // showNotification() async {
  //   setState(() {
  //     _counter++;
  //   });

  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       "Alusoft App",
  //       controller.text,
  //       tz.TZDateTime.now(tz.local).add(Duration(seconds: 3)),
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(channel.id, channel.name,
  //               importance: Importance.high,
  //               color: Colors.pink,
  //               playSound: true,
  //               icon: '@mipmap/launcher_icon')),
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       androidAllowWhileIdle: true);
  //   if (NotificationDetails != null) {
  //     showDialog(
  //         context: context,
  //         builder: (_) {
  //           return AlertDialog(
  //             title: Text(""),
  //           );
  //         });
  //   }

  //   print("Hey");
  // }

  ParticleOptions particles = const ParticleOptions(
      baseColor: Colors.black,
      spawnOpacity: 0.0,
      opacityChangeRate: 0.25,
      minOpacity: 0.1,
      maxOpacity: 0.4,
      particleCount: 70,
      spawnMaxRadius: 15.0,
      spawnMaxSpeed: 300.0,
      spawnMinSpeed: 300,
      spawnMinRadius: 7.0);

  //getting the USER DETAILS
  final user = FirebaseAuth.instance.currentUser!;

  //DateTimeObject
  DateTime dateTime = DateTime(2022, 12, 24, 5, 30);

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, "0");
    final minutes = dateTime.minute.toString().padLeft(2, "0");
    return AnimatedBackground(
      vsync: this,
      behaviour: RandomParticleBehaviour(options: particles),
      child: AlertDialog(
        backgroundColor: Colors.purple[100],
        content: Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Add a new Task",
                ),
              ),

              TextField(
                controller: widget.SubTask,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Add a sub Task",
                ),
              ),

              TextField(
                // controller: widget.controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Time",
                    suffixIcon: GestureDetector(
                        onTap: pickDateTime,
                        // onTap: () async {

                        //   // final date = await pickDate();
                        //   // if (date == null) return;

                        //   // final newDateTime = DateTime(date.year, date.month,
                        //   //     date.day, dateTime.hour, dateTime.minute);

                        //   // setState(() {
                        //   //   dateTime = newDateTime;
                        //   // });
                        // },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${dateTime.year} /${dateTime.month}/${dateTime.day} $hours:$minutes"),
                              Icon(Icons.calendar_month),
                            ],
                          ),
                        ))),
              ),
              // TextField(
              //   controller: widget.timeController,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     hintText: "Add Time",
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(
                    text: "Save",
                    onPressed: widget.onSave,
                  ),
                  SizedBox(width: 8),
                  MyButton(
                    text: "Cancel",
                    onPressed: widget.onCancel,
                  )
                ],
              ),

              Text(user.displayName!)
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  Future pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    setState(() {
      this.dateTime = dateTime;
    });
  }
}
