// import 'package:flutter/material.dart';
// import 'package:todo_app/api/google_sheets_api.dart';
// import 'package:todo_app/pages/todopage/textbox.dart';

// class NotesGrid extends StatelessWidget {
//   NotesGrid({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//         itemCount: GoogleSheetsApi.currentNotes.length,
//         gridDelegate:
//             SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//         itemBuilder: (BuildContext context, int index) {
//           return MyTextBox(text: GoogleSheetsApi.currentNotes[index][0]);
//         });
//   }
// }
