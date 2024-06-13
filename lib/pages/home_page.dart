import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginui/pages/book_page.dart';
import 'package:loginui/pages/contact_page.dart';
import 'package:loginui/pages/profile_page.dart';
import 'package:loginui/pages/student_page.dart';
import 'package:loginui/pages/teacher_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 79, 179, 241),
          foregroundColor: Colors.black,
          title: Row(
            children: [
              Icon(Icons.menu_book, size: 25),
              SizedBox(width: 8),
              Text(
                'Prathibhatheeram',
                style: GoogleFonts.aladin(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Books are the quietest and most constant of friends; they are the most accessible and wisest of counselors, and the most patient of teachers. - Charles William Eliot",
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
              ),
              _buildSection("Novels", [
                'https://tse1.mm.bing.net/th?id=OIP.XVyxmyS4jvmZuXpluVHNzgHaL7&pid=Api&P=0&h=180',
                'https://tse4.mm.bing.net/th?id=OIP.su1bQjOBMuzCMUYLxrKI6QHaLH&pid=Api&P=0&h=180',
                'https://tse4.mm.bing.net/th?id=OIP._I3mUgPn2UWllDgKSswFrgHaKw&pid=Api&P=0&h=180',
                'https://tse4.mm.bing.net/th?id=OIP.J7m6VrNbX0q1CrFHdxP5pwHaLM&pid=Api&P=0&h=180',
                'https://tse2.mm.bing.net/th?id=OIP.JsK_QbeG3uk9cnhIj3Mj2AAAAA&pid=Api&P=0&h=180',
              ]),
              SizedBox(height: 20),
              _buildSection("Magazines", [
                'https://tse2.mm.bing.net/th?id=OIP.lXkmHwtmBnnHRaK8xQ1LGgHaLZ&pid=Api&P=0&h=180',
                'https://tse3.mm.bing.net/th?id=OIP.YqypqlEMooyiWeFj44aYYwHaLY&pid=Api&P=0&h=180',
                'https://tse1.mm.bing.net/th?id=OIP.HlvP-cSd0h3yI9KVNGoxygHaLG&pid=Api&P=0&h=180',
                'https://tse2.mm.bing.net/th?id=OIP.lXkmHwtmBnnHRaK8xQ1LGgHaLZ&pid=Api&P=0&h=180',
                'https://tse2.mm.bing.net/th?id=OIP.A8tvGtxL7BQbkSdD_7rgkgHaLS&pid=Api&P=0&h=180',
              ]),
            ],
          ),
        ),
      ),
      BookPage(),
      TeacherPage(),
      StudentPage(),
      ProfilePage(),
      ContactPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 79, 179, 241),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 79, 179, 241),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 79, 179, 241),
            icon: Icon(Icons.menu_book),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 79, 179, 241),
            icon: Icon(Icons.book),
            label: 'Teacher',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 79, 179, 241),
            icon: Icon(Icons.school),
            label: 'Student',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 79, 179, 241),
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildSection(String title, List<String> imageUrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 5),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var imageUrl in imageUrls)
                BookCard(
                  imageUrl: imageUrl,
                ),
              GestureDetector(
                onTap: () {
                  // Navigate to another page or perform any action
                  // For example:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'See More >',
                    style: GoogleFonts.aladin(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class BookCard extends StatelessWidget {
  final String imageUrl;

  const BookCard({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => SizedBox(
                  width: 50, // Adjust the width as needed
                  height: 50, // Adjust the height as needed
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0, // Adjust the stroke width as needed
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: 100, // Set the width of the image
                height: 150, // Set the height of the image
              ),
            ],
          ),
        ),
      ],
    );
  }
}
