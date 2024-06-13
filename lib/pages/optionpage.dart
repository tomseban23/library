import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OptionsPage extends StatefulWidget {
  final String? bookName;
  final String? id;
  final String? teacherId;

  OptionsPage({this.bookName, this.id, this.teacherId});
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  final _liveNameController = TextEditingController();
  final _bookController = TextEditingController();
  // final _dueDateController = TextEditingController();
  final _stdController = TextEditingController();
  final _teacherController = TextEditingController();
  final _bookidController = TextEditingController();
  final _divisionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bookController.text = widget.bookName ?? '';
    _bookidController.text = widget.id ?? '';
    _teacherController.text = widget.teacherId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 79, 179, 241),
        title: Text('Options'),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _bookController,
                decoration: InputDecoration(
                  labelText: 'Book Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 5.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _bookidController,
                decoration: InputDecoration(
                  labelText: 'Book id',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 5.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _teacherController,
                decoration: InputDecoration(
                  labelText: 'teacher id',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 5.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _liveNameController,
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 5.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _stdController,
                decoration: InputDecoration(
                  labelText: 'Std',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 5.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _divisionController,
                decoration: InputDecoration(
                  labelText: 'division',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 5.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  saveOptions(context);
                },
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveOptions(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve existing options data
    final existingOptions = prefs.getStringList('options') ?? [];

    // Add the new options to the existing data
    final newOptions = {
      'studentName': _liveNameController.text,
      'standard': _stdController.text,
      'teacherId': _teacherController.text,
      'division': _divisionController.text,
      'bookId': _bookidController.text,
      'bookName': _bookController.text,
    };
    existingOptions.add(newOptions.toString());

    // Save the updated options data
    prefs.setStringList('options', existingOptions);

    // Send the data to the backend
    final url = 'http://192.168.1.11:3000/student_issues/issue_book';

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(newOptions), // Convert to JSON format
    );

    // Check the response status
    if (response.statusCode == 200) {
      print('Data sent successfully to the backend');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blue,
          content: Center(
              child: Text(
            'Successful ',
            style: TextStyle(color: Colors.white),
          )),
          duration: Duration(seconds: 1), // Adjust duration as needed
        ),
      );
      // Handle successful response here
    } else {
      print(
          'Failed to send data to the backend. Status code: ${response.statusCode}');
      // Handle failure here
    }

    // Navigate back to the previous screen
    Navigator.pop(context, newOptions);
  }
}
