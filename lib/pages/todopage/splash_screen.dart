import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/login_page.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> with SingleTickerProviderStateMixin {
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

  @override
  void initState() {
    super.initState();
    const delay = Duration(seconds: 7);
    Future.delayed(delay, () => onTimer());
  }

  void onTimer() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedBackground(
          vsync: this,
          behaviour: RandomParticleBehaviour(options: particles),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/todo.jpeg",
                height: 20,
              ),
              Center(
                child: Text(
                  "ALANME!!!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
        ));
  }
}
