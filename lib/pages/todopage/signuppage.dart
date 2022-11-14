import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:alan_voice/alan_voice.dart';
import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/pages/login_page.dart';
import 'package:todo_app/pages/todopage/advancedpage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  ParticleOptions particles = const ParticleOptions(
      baseColor: Colors.deepPurple,
      spawnOpacity: 0.0,
      opacityChangeRate: 0.25,
      minOpacity: 0.1,
      maxOpacity: 0.4,
      particleCount: 70,
      spawnMaxRadius: 15.0,
      spawnMaxSpeed: 300.0,
      spawnMinSpeed: 300,
      spawnMinRadius: 7.0);

  //displaying different texts flutter
  bool showWidget = false;

  receiveResponsefromTimer() {
    setState(() {
      showWidget = true;
    });
  }

  setTimer() {
    var duration = Duration(seconds: 2);
    return Timer(duration, receiveResponsefromTimer());
  }

  final TextEditingController name = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController LastName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController _punmber = TextEditingController();

  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

  bool validateEmail(String value) {
    dynamic pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

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

  void _handleCommand(Map<String, dynamic> command) {
    switch (command['command']) {
      // case "remind":
      //   _post();
      //   break;
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

      case "getPassword": //password textfield
        password.text = command['text'];

        break;

      default:
        debugPrint('Unknown command');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // MyHomePageState();
  }

  //Profile Picture Image
  File? _image;
  String? imageUrl;

  //dialog box for the profile Picture

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Please choose an option"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                      onTap: () {
                        _getFromCamera();
                        // get from Camera
                      },
                      child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(Icons.camera, color: Colors.red)),
                          Text("Camera", style: TextStyle(color: Colors.pink))
                        ],
                      )),
                  SizedBox(height: 20),
                  InkWell(
                      onTap: () {
                        _getFromGallery();
                        //get from Gallery
                      },
                      child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(Icons.image, color: Colors.red)),
                          Text("Gallery", style: TextStyle(color: Colors.pink))
                        ],
                      ))
                ],
              ));
        });
  }

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        _image = File(croppedImage.path);
      });
    }
  }

  //for Password Confirmation
  bool passwordConfirmed() {
    if (password.text.trim() == confirmPassword.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  //save the data in the cloud firestore
  Future signUp() async {
    if (passwordConfirmed()) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('userImages')
          .child(DateTime.now().toString() + '.jpg');

      await ref.putFile(_image!);
      imageUrl = await ref.getDownloadURL();

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        return result.user!
            .updateDisplayName("${firstName.text + " " + LastName.text}");
      });

      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
        'uid': user.uid,
        'email': email.text,
        'password': password.text,
        'firstName': firstName.text,
        'LastName': LastName.text,
        //'role': user,
        'displayName': user.displayName,
        'userImage': imageUrl,
      });
      setState(() {});

      final snackBar = SnackBar(
        content: const Text('Successfully created  a login account'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Some code to undo the change.
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => LoginPage())));
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
  }

  //form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Create Account",
          style: TextStyle(color: Colors.deepPurple, fontSize: 20),
        ),
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginPage()));
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.deepPurple,
          ),
        ),
      ),
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particles),
        child: InkWell(
          onTap: () {
            setState(() {
              FocusManager.instance.primaryFocus!.unfocus();
            });
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                          child: (_image == null)
                              ? Icon(
                                  Icons.person_outline,
                                  color: Colors.grey,
                                  size: 120,
                                )
                              : Image.file(
                                  _image!,
                                  fit: BoxFit.fill,
                                  height: 120,
                                )),
                      Padding(
                          padding: EdgeInsets.only(top: 60.0),
                          child: IconButton(
                            icon: Icon(FontAwesomeIcons.camera, size: 30.0),
                            onPressed: () {
                              _showImageDialog();
                              //  getImage();
                            },
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: firstName,
                      decoration: InputDecoration(
                          hintText: "First Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: LastName,
                      decoration: InputDecoration(
                          hintText: "Last Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: [AutofillHints.email],
                      controller: email,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? "Enter a valid email"
                              : null,
                      autovalidateMode: AutovalidateMode.always,
                      decoration: InputDecoration(
                          hintText: "Email Address",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _punmber,
                      validator: (value) {
                        if (value!.isEmpty == true ||
                            value == "" ||
                            value.length < 11) {
                          return "Enter a valid Phone Number";
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Phone-Number",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: password,
                      decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: confirmPassword,
                      decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  GestureDetector(
                    onTap: () {
                      final form = _formKey.currentState;
                      if (form!.validate() && _image != null) {
                        Loader.show(
                          context,
                          isSafeAreaOverlay: false,
                          isBottomBarOverlay: false,
                          overlayFromBottom: 0,
                          overlayColor: Colors.grey,
                          progressIndicator: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                  backgroundColor: Colors.red),
                              Text(
                                "Verifying your account! Please wait....",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              )
                            ],
                          ),
                          themeData: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.fromSwatch()
                                  .copyWith(secondary: Colors.green)),
                        );

                        signUp();

                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => LoginPage()));

                        Future.delayed(Duration(seconds: 10), () {
                          Loader.hide();
                        });
                      }
                    },
                    child: Center(
                      child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.purple),
                          child: Center(
                              child: Text("Sign Up",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)))),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        print("You tapped me");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text("Sign In",
                          style: TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.combine(
                                [
                                  TextDecoration.underline,
                                ],
                              ),
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
