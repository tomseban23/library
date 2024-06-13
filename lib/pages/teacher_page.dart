import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loginui/pages/optionpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherPage extends StatefulWidget {
  TeacherPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  late String userId = '';
  late List<Books> allBooks;
  late List<Books> filteredBooks;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    filteredBooks = [];
    allBooks = [];
    searchController = TextEditingController();
    getUserId().then((value) {
      setState(() {
        userId = value ?? ''; // Default value if userId is null
      });
      fetchBooks(userId);
    });
  }

  @override
  void dispose() {
    // Clean up resources
    searchController.dispose();
    super.dispose();
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> fetchBooks(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.11:3000/issues/allissuedbooks'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Received data for teacher: $data');

        List<Books> teacherBooks = [];
        Set<String> uniqueBookIds = Set(); // Set to store unique book IDs

        for (var item in data) {
          Books book = Books.fromJson(item);
          if (book.teacherId.toLowerCase() == userId.toLowerCase() &&
              !uniqueBookIds.contains(book.id)) {
            teacherBooks.add(book);
            uniqueBookIds.add(book.id);
          }
        }

        setState(() {
          allBooks = teacherBooks;
          filteredBooks = List.from(allBooks);
        });
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching books: $e');
    }
  }

  void filterBooks(String query) {
    try {
      List<Books> filtered = allBooks.where((book) {
        return book.bookName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      setState(() {
        filteredBooks = filtered;
      });
    } catch (e) {
      print("Error filtering books: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 79, 179, 241),
        title: Row(
          children: [
            Icon(Icons.person_add_alt_1_outlined),
            SizedBox(width: 8),
            Text(
              'Teacher ID: $userId',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchBooks(userId); // Refresh the books list
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterBooks(value);
              },
              decoration: InputDecoration(
                hintText: 'Search....',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];
                // Add condition to check if quantity is greater than zero
                if (int.parse(book.quantity) > 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Left side containing book details
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.bookName,
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text('Book Id  :  ${book.id}',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 4),
                                Text('Issue Date  :  ${book.issueDate}',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 4),
                                Text('Return Date  :  ${book.returnDate}',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 4),
                                Text('Quantity  :  ${book.quantity}',
                                    style: TextStyle(fontSize: 16)),
                                // SizedBox(height: 4),
                                // Text('Division  :  ${book.division}',
                                //     style: TextStyle(fontSize: 16)),
                                // SizedBox(height: 4),
                                // Text('Subject  :  ${book.subject}',
                                //     style: TextStyle(fontSize: 16)),
                                SizedBox(height: 4),
                                Text('Teacher Id  :  ${book.teacherId}',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            // // Right side containing "Issue Book" button
                            GestureDetector(
                              onTap: () {
                                // Navigate to the option page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OptionsPage(
                                      bookName: book.bookName,
                                      id: book.id,
                                      teacherId: book.teacherId,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Issue Book',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  // Return an empty container if quantity is zero
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Books {
  final String bookName;
  final String issueDate;
  final String returnDate;
  final String std;
  final String division;
  final String subject;
  final String id;
  final String teacherId;
  final String quantity;

  Books(
      {required this.bookName,
      required this.issueDate,
      required this.returnDate,
      required this.std,
      required this.division,
      required this.subject,
      required this.id,
      required this.teacherId,
      required this.quantity});

  factory Books.fromJson(Map<String, dynamic> json) {
    return Books(
      bookName: json['bookName'] != null ? json['bookName'] : 'Unknown Title',
      issueDate:
          json['issueDate'] != null ? json['issueDate'] : 'Unknown Issue Date',
      quantity: json['quantity'] != null
          ? json['quantity'].toString()
          : 'Unknown quantity',
      returnDate: json['returnDate'] != null
          ? json['returnDate']
          : 'Unknown Return Date',
      std: json['class'] != null ? json['class'].toString() : 'Unknown Class',
      division:
          json['division'] != null ? json['division'] : 'Unknown Division',
      subject: json['subject'] != null ? json['subject'] : 'Unknown Subject',
      id: json['bookId'] != null ? json['bookId'].toString() : 'Unknown id',
      teacherId: json['teacherId'] != null
          ? json['teacherId'].toString()
          : 'Unknown teacherId',
    );
  }
}
