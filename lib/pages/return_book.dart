// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ReturnPage extends StatefulWidget {
//   @override
//   _ReturnPageState createState() => _ReturnPageState();
// }

// class _ReturnPageState extends State<ReturnPage> {
//   final TextEditingController _studentNameController = TextEditingController();
//   final TextEditingController _idController = TextEditingController();

//   Future<void> _submitReturnData() async {
//     // Get the student name and book ID from the text fields
//     final String studentName = _studentNameController.text;
//     final String id = _idController.text;

//     // Send the data to the backend (replace this with your actual backend call)
//     try {
//       final response = await http.post(
//         Uri.parse(
//             'http://192.168.1.26:8080/student_return/return-book-by-student?bookId=$id&studentName=$studentName'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'studentName': studentName,
//           'id': id,
//         }),
//       );

//       // Handle the response from the backend
//       if (response.statusCode == 200) {
//         print('Detail sent successfully');
//       } else {
//         print('error occured');
//       }
//     } catch (e) {
//       print('Error fetching books: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFffbe98),
//         title: Text('Return Books'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _studentNameController,
//               decoration: InputDecoration(
//                 labelText: 'Student Name',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _idController,
//               decoration: InputDecoration(
//                 labelText: 'Book ID',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _submitReturnData,
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
