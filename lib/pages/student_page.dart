import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<Map<String, dynamic>> studentDataList = [];
  List<Map<String, dynamic>> filteredStudentDataList = [];
  final String apiUrl = 'http://192.168.1.11:3000/student_issues/issued-books';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    loadStudentData();
  }

  Future<void> loadStudentData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Received data for student: $data');
        setState(() {
          studentDataList =
              List.from(data.map((item) => parseStudentData(item)));
          filteredStudentDataList = List.from(studentDataList);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load student data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading student data: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> parseStudentData(dynamic data) {
    return {
      'studentName': data['studentName'],
      'bookId': data['bookId'],
      'bookName': data['bookName'],
      'standard': data['standard'],
      'division': data['division'],
      'issueDate': data['issueDate'],
      'returnDate': data['returnDate'],
      'teacherName': data['teacherName'],
    };
  }

  void _filterStudentData(String query) {
    setState(() {
      filteredStudentDataList = studentDataList.where((studentData) {
        final studentName = studentData['studentName'].toString().toLowerCase();
        final bookName = studentData['bookName'].toString().toLowerCase();
        return studentName.contains(query.toLowerCase()) ||
            bookName.contains(query.toLowerCase());
      }).toList();
    });
  }

  String formattedDate(String date) {
    return date;
  }

  Future<void> _returnBook(String studentName, String bookId) async {
    bool confirmReturn = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Return"),
          content: Text(
              "Are you sure you want to return the book for $studentName?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Return"),
            ),
          ],
        );
      },
    );

    if (confirmReturn == true) {
      print('Returning book from Student: $studentName, Book ID: $bookId');

      try {
        final response = await http.post(
          Uri.parse(
              'http://192.168.1.11:3000/student_return/return-book-by-student?bookId=$bookId&studentName=$studentName'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'studentName': studentName,
            'bookId': bookId,
          }),
        );

        if (response.statusCode == 200) {
          print('Book returned successfully');
          await loadStudentData();
        } else {
          throw Exception('Failed to return book: ${response.statusCode}');
        }
      } catch (e) {
        print('Error returning book: $e');
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 79, 179, 241),
        title: Row(
          children: [
            Icon(Icons.school),
            SizedBox(width: 10),
            Text(
              'Student Details',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Text('Failed to load student data.'),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterStudentData,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterStudentData('');
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredStudentDataList.length,
                        itemBuilder: (context, index) {
                          final studentData = filteredStudentDataList[index];
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Student Name: ${studentData['studentName']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Book Name: ${studentData['bookName']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Book ID: ${studentData['bookId']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Teacher Name: ${studentData['teacherName']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Std: ${studentData['standard']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Division: ${studentData['division']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Issue Date: ${formattedDate(studentData['issueDate'])}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Return Date: ${formattedDate(studentData['returnDate'])}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Divider(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (studentData['studentName'] !=
                                                null &&
                                            studentData['bookId'] != null) {
                                          _returnBook(
                                              studentData['studentName'],
                                              studentData['bookId'].toString());
                                        }
                                      },
                                      child: Text('Return'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
