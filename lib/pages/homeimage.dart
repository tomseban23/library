// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:loginui/pages/book_page.dart';

// class BookImageWidget extends StatefulWidget {
//   @override
//   _BookImageWidgetState createState() => _BookImageWidgetState();
// }

// class _BookImageWidgetState extends State<BookImageWidget> {
//   late List<Books> allBooks;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     allBooks = [];
//     fetchBooks();
//   }

//   Future<void> fetchBooks() async {
//     try {
//       final response = await http
//           .get(Uri.parse('http://192.168.1.16:8080/library/getAllBooks'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         setState(() {
//           allBooks = data.map((item) => Books.fromJson(item)).toList();
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load books: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching books: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? Center(child: CircularProgressIndicator())
//         : GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//             ),
//             itemCount: allBooks.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.all(3.0),
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.25,
//                   child: Card(
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child:
//                               allBooks[index].getImageWidget() ?? Container(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
//                           child: Text(
//                             allBooks[index].bookName,
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//   }
// }
