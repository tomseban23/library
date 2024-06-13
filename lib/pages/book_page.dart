import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookPage extends StatefulWidget {
  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late List<Books> allBooks;
  late List<Books> filteredBooks;
  late TextEditingController searchController;
  late SharedPreferences prefs;
  final ScrollController _scrollController = ScrollController();
  final String apiUrl = 'http://192.168.1.11:3000/library/getAllBooks';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    filteredBooks = [];
    allBooks = [];
    searchController = TextEditingController();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          allBooks = data.map((item) => Books.fromJson(item)).toList();
          filteredBooks = List.from(allBooks);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching books: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterBooks(String query) {
    List<Books> filtered = allBooks.where((book) {
      return book.bookName.toLowerCase().contains(query.toLowerCase()) ||
          book.authorName.toLowerCase().contains(query.toLowerCase()) ||
          book.category.toLowerCase().contains(query.toLowerCase()) ||
          book.language.toLowerCase().contains(query.toLowerCase()) ||
          book.id.toString().toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredBooks = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 79, 179, 241),
        foregroundColor: Colors.black,
        title: Row(
          children: [
            Icon(Icons.menu_book, size: 25),
            SizedBox(width: 8),
            Text(
              'Books',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.6),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: (filteredBooks.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      final startIndex = index * 2;
                      final endIndex = startIndex + 2;
                      final booksChunk = filteredBooks.sublist(
                          startIndex, endIndex.clamp(0, filteredBooks.length));
                      return Row(
                        children: booksChunk
                            .map((book) => Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 10.0),
                                                title: Text(
                                                  book.bookName,
                                                  style: GoogleFonts.aladin(
                                                      fontSize: 25.0),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      ListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        leading: Icon(
                                                            Icons.info,
                                                            size: 24.0,
                                                            color: Colors.blue),
                                                        title: Text(
                                                          'Book Id',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          '${book.id}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Divider(),
                                                      ListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        leading: Icon(
                                                            Icons.person,
                                                            size: 24.0,
                                                            color:
                                                                Colors.green),
                                                        title: Text(
                                                          'Author',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          '${book.authorName}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Divider(),
                                                      ListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        leading: Icon(
                                                            Icons.category,
                                                            size: 24.0,
                                                            color:
                                                                Colors.orange),
                                                        title: Text(
                                                          'Category',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          '${book.category}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Divider(),
                                                      ListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        leading: Icon(
                                                            Icons.language,
                                                            size: 24.0,
                                                            color:
                                                                Colors.purple),
                                                        title: Text(
                                                          'Language',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          '${book.language}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Divider(),
                                                      ListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        leading: Icon(
                                                            Icons.inventory,
                                                            size: 24.0,
                                                            color:
                                                                book.quantity ==
                                                                        0
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .blue),
                                                        title: Text(
                                                          'Quantity',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          book.quantity == 0
                                                              ? 'Not Available'
                                                              : '${book.quantity}',
                                                          style: TextStyle(
                                                            color:
                                                                book.quantity ==
                                                                        0
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(),
                                                      ListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        leading: Icon(
                                                            Icons.book,
                                                            size: 24.0,
                                                            color: Colors
                                                                .deepOrange),
                                                        title: Text(
                                                          'Rack',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          '${book.rack}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (book.getImageWidget() != null)
                                                book.getImageWidget()!,
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0, bottom: 2.0),
                                                child: Text(
                                                  book.bookName,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0, bottom: 2.0),
                                                child: Text(
                                                  'Author: ${book.authorName}',
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}

class Books {
  final int id;
  final String bookName;
  final String authorName;
  final String category;
  final String language;
  final int quantity;
  final int rack;
  final String image;
  bool showDetails;

  Books({
    required this.id,
    required this.bookName,
    required this.authorName,
    required this.category,
    required this.language,
    required this.quantity,
    required this.rack,
    required this.image,
    this.showDetails = false,
  });

  factory Books.fromJson(Map<String, dynamic> json) {
    return Books(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      bookName: json['bookName'] ?? 'Unknown Title',
      authorName: json['authorName'] ?? 'Unknown Author',
      category: json['category'] ?? 'Unknown Category',
      language: json['language'] ?? 'Unknown Language',
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.parse(json['quantity']),
      rack: json['rack'] is int ? json['rack'] : int.parse(json['rack']),
      image: json['image'] ?? '',
    );
  }
  Widget? getImageWidget() {
    if (image.isNotEmpty) {
      Uint8List bytes = base64Decode(image);
      return Builder(
        builder: (BuildContext context) {
          Image imageWidget = Image.memory(bytes);
          return Container(
            height: imageWidget.height?.toDouble(),
            width: imageWidget.width?.toDouble(),
            child: imageWidget,
          );
        },
      );
    } else {
      return null; // Return null if image is empty
    }
  }
}
