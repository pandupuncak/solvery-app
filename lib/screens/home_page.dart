import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_drive/providers/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tukang.in"),
        leading: InkWell(
          onTap: () {
            context.read<Authentication>().signOut();
          },
          child: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 242, 146, 2),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(40),
            color: Colors.white,
            child: Text('Search Bar'),
          ),
          Row(
            children: [
              Container(child: Text("Cash"), padding: EdgeInsets.all(40))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Hi!",
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            children: [
              InkWell(
                child: Image.asset('assets/images/repair.png'),
                onTap: () {
                  Navigator.pushNamed(context, '/repair');
                },
              ),
              InkWell(
                child: Image.asset('assets/images/build.png'),
              ),
              InkWell(
                child: Image.asset('assets/images/repair.png'),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Orders',
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.orange,
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.orange,
      //   child: IconTheme(
      //     data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      //     child: Row(
      //       children: [
      //         IconButton(
      //           onPressed: () {},
      //           icon: const Icon(Icons.home),
      //         ),
      //         IconButton(
      //           onPressed: () {},
      //            icon: const Icon(Icons.chat_bubble),
      //         ),
      //         IconButton(
      //           onPressed:(){} ,
      //           icon: const Icon(Icons.list_alt_rounded),
      //         ),
      //         IconButton(
      //           onPressed: () {},
      //         icon: const Icon(Icons.person),
      //         )
      //       ],)
      //   ),
      // ),
    );
  }
}
