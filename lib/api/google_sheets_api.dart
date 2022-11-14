// import 'package:gsheets/gsheets.dart';

// class GoogleSheetsApi {
//   static const _credentials = r'''

// {
//   "type": "service_account",
//   "project_id": "flutter-todoapp-365816",
//   "private_key_id": "db85bb577d0a71f1bda1da9be522911c46d55b63",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDORrD/HSyGApZa\nyPUHQC023Tm5MVrb7Zf53bWwc2JyQq7TO2IUIoyBL3ZPS+FH5DIPN5RPsk6fghIs\n2ea8En4M84ZOmOskLC2uom3S1cp/YgKNzqWisxD6O8dXNk1emTpZ+kr7nG9Wou5e\nvWXq+hvr1hPhVeCQRZdzjLjHujwwyg9R312kKZup4xRHT+Twnrv3FTa6vJfjENG7\n9sHrkRTwxyuZrcRXkALkX01Mi9SHxUhYoYzInZsUPZuPQJH/oTnXfouo+W/t7Dom\nVk9vJ6e+hPdWzxBbphnZEB7Dzq3V5CJEypbM0JVxLf/Vk8udalI1mpKQNOz0ZBCX\neBV8bmlpAgMBAAECggEAC1QtQGBKeQmyAZvBKVFy/5e4Jd2kudNwt1O1ONL9eH0F\nEQDVQCSC8aK5ArM41N6e3osU5X5LfHiDpbGfTyZM2fU9+RnDlaGqLfR/HPHfmeNj\ndIUBlSVJ12m/vEsf21mFr49kMtwX7qWAJfU3oGd1b8cQIci6TpzOgUAcneDdPBNO\nSjGK4C4ohX1ov7WlLy94KKfYGsgCXKXrkMCpot7sR0k+POZAnggdFzZb68t57wif\nPRTvnSKxgFZhkbkv7Hi10kxNiNndTq+XSd31HgsdcH0sHcfKkvfrqEl+tS9QPxDG\nvZU1r485pLUYiC1hMBL5MbiH3YN4XorKgMm7lu5zaQKBgQDmtATDfPuHavot3BU7\no2IwDgGXaH25R8TTLJH1ZNSdGqwH33NHbIjC8uGwemQPg3ovD8ZFgr0PQympiCSD\n8OhifwbfBYqPNWETTd/K4G5XzzaIO/ZMriGvms+RbruNUEgjrym/Bs+z7noxqscc\n3ZLfmIvc7G486lzBN+qp6KdJcwKBgQDk5P14yrE60fPJ798hxkp8caKTU/HIy7xz\nTGDiFiFiApGqncqSnU8BZuKHSHRFblLnL87yuY0APrZmYTGnhUPMFWmCQtd3dxe+\nGCYsFC8VW0bmMakV/FXOzFLtHLIDAIjB3cB5XEueO1X5sxR37X3uOb13tgf88oW9\n+k1Vh2Y6swKBgCcCxdNwrO/HLSrYDlcZV58cnzRFHQ1Zj3TOEphWRoWSXwitxkaL\nmcytWXCIIadl6iFPH43df663ArKCLPqKoCEXrcfEnht9QT8Mag1aSg5bIbODwDBT\nOasCGJtVCC3rJ2exVPPSaQjaCJuhby34Yb+hgfUHndR7JNgfZnT4vGD1AoGBAM/2\nnbVZs5zVlMIshnaRSqu2MxfYdR0Svq2i/4Nqx/nci6yQoLSE6HtFlxuC4OEUU45p\nCYXOwCUw1Vg/hnXFxsttyObpBAsu0QuNtWDnFcA5pjkPdajcErpJOi7km3fOzHIX\noACjsrCZCIxOAJLV3EzNeS+C288eKhVpjUngMymxAoGADmQuMGAyjAzyksRktFhC\nSFiVQaQBn+kED7X3qUubaSSVZcja6UsrIiz8HCfRgJdfUxiOapvAg25I7nhvFPc9\ntqTRrHWjQ52hFe208VcsHqsOVOi2bTjmI4+3jkseSaNLbLIOSdn1qwX1y+nCffd5\nXC7C6FWypRXKkb8TkzRqVAo=\n-----END PRIVATE KEY-----\n",
//   "client_email": "flutter-todoapp@flutter-todoapp-365816.iam.gserviceaccount.com",
//   "client_id": "102147347446864330788",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-todoapp%40flutter-todoapp-365816.iam.gserviceaccount.com"
// }


// ''';

//   static final _spreadsheetId = '1jjxsb7OzdS4KiA1C_8d0DTojbTm_6m9v1eT9JJGR1lc/';
//   final gsheets = GSheets(_credentials);
//   static Worksheet? _worksheet;

//   //some variables to keep track of..
//   static int numberOfNotes = 0;
//   static List<List<dynamic>> currentNotes = [];
//   static bool loading = true;

//   Future init() async {
//     final ss = await gsheets.spreadsheet(_spreadsheetId);
//     _worksheet = ss.worksheetByTitle('Worksheet1');
//     countRows();
//   }

//   // count the number of rows
//   static Future countRows() async {
//     while (
//         (await _worksheet!.values.value(column: 1, row: numberOfNotes + 1)) !=
//             "") {
//       numberOfNotes++;
//     }
//     loadNotes();
//   }

//   static Future loadNotes() async {
//     if (_worksheet == null) return;

//     for (int i = 0; i < numberOfNotes; i++) {
//       final String newNote =
//           await _worksheet!.values.value(column: 1, row: i + 1);
//       if (currentNotes.length < numberOfNotes) {
//         currentNotes.add([
//           newNote,
//           int.parse(await _worksheet!.values.value(column: 2, row: i + 1))
//         ]);
//       }
//     }

//     loading = false;
//   }

//   //insert a new note
//   static Future insert(String note) async {
//     if (_worksheet == null) return;
//     numberOfNotes;
//     currentNotes.add([note, 0]);
//     await _worksheet!.values.appendRow([note, 0]);
//   }

//   static Future update(int index, int isTaskCompleted) async {
//     _worksheet!.values.insertValue(isTaskCompleted, column: 2, row: index + 1);
//   }
// }
