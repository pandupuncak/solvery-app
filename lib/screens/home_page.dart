import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_drive/providers/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_drive/providers/palette.dart';

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
        title: Text(
          "Tukang.in",
          style: Theme.of(context).textTheme.headline2,
        ),
        leading: InkWell(
          onTap: () {
            context.read<Authentication>().signOut();
            Navigator.pushNamed(context, '/auth');
          },
          child: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 242, 146, 2),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 372,
                height: 28,
                //color: Colors.white,
                child: Text(
                  'Search Service/Design',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                decoration: BoxDecoration(
                    // border: Border.all(
                    //     //color: Colors.black,
                    //     //style: BorderStyle.solid,
                    //     ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Palette.shadow,
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      )
                    ]),
                padding: EdgeInsets.all(6),
              ),
            ),
            Container(
              //color: Colors.orange,
              child: Row(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Positioned(
                          child: Text(
                            "Cash",
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.left,
                          ),
                          bottom: 40,
                        ),
                        Positioned(
                          child: Text(
                            "Rp.10.000",
                            style: TextStyle(
                              fontFamily: 'SourceSansPro',
                              fontSize: 16.0,
                            ),
                          ),
                          bottom: 10,
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Palette.yellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 112,
                    height: 79,
                  ),
                  Positioned(
                    child: Container(
                      child: Stack(
                        children: [
                          Positioned(
                            child: Container(
                              width: 52.775020599365234,
                              height: 49.999961853027344,
                              decoration: BoxDecoration(
                                color: Palette.yellow,
                                borderRadius: BorderRadius.all(
                                  Radius.elliptical(
                                      52.775020599365234, 49.999961853027344),
                                ),
                              ),
                            ),
                            top: 0,
                            left: 30,
                          ),
                          Positioned(
                            child: Container(
                              width: 52.775020599365234,
                              height: 49.999961853027344,
                              decoration: BoxDecoration(
                                color: Palette.yellow,
                                borderRadius: BorderRadius.all(
                                  Radius.elliptical(
                                      52.775020599365234, 49.999961853027344),
                                ),
                              ),
                            ),
                            top: 0,
                            left: 90,
                          ),
                          Positioned(
                            child: Container(
                              width: 52.775020599365234,
                              height: 49.999961853027344,
                              decoration: BoxDecoration(
                                color: Palette.yellow,
                                borderRadius: BorderRadius.all(
                                  Radius.elliptical(
                                      52.775020599365234, 49.999961853027344),
                                ),
                              ),
                            ),
                            top: 0,
                            left: 150,
                          ),
                        ],
                      ),
                      width: 200,
                      height: 50,
                    ),
                  )
                ],
              ),
              width: 372,
              height: 117,
              decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.black,
                  //   style: BorderStyle.solid,
                  // ),
                  borderRadius: BorderRadius.circular(20),
                  color: Palette.darkyellow,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.shadow,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    )
                  ]),
              padding: EdgeInsets.all(10),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Hi!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Container(
              child: Text(
                "Choose Service",
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.left,
              ),
              //decoration: BoxDecoration(color: Colors.green),
              width: 350,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Image.asset('assets/images/repair.png'),
                    onTap: () {
                      Navigator.pushNamed(context, '/repair');
                    },
                  ),
                  Spacer(),
                  InkWell(
                    child: Image.asset('assets/images/build.png'),
                  ),
                  Spacer(),
                  InkWell(
                    child: Image.asset('assets/images/design.png'),
                    onTap: () {
                      Navigator.pushNamed(context, '/design');
                    },
                  ),
                ],
              ),
              width: 372,
              padding: EdgeInsets.all(10),
            ),
            Container(
              child: Text(
                "Advertisement",
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.left,
              ),
              width: 350,
              padding: EdgeInsets.all(10),
            ),
            SizedBox(
              height: 100.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    width: 200.0,
                    //color: Colors.red,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/ad_1.jpg'),
                        ),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Container(
                      width: 200.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/ad_2.jpg'),
                          ),
                          borderRadius: BorderRadius.circular(20))
                      //color: Colors.blue,
                      ),
                  Container(
                    width: 200.0,
                    //color: Colors.green,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "More Help",
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Container(
              //color: Palette.yellow,
              decoration: BoxDecoration(
                  color: Palette.yellow,
                  borderRadius: BorderRadius.circular(20)),
              child: Stack(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Positioned(
                    child: Icon(
                      Icons.info,
                      size: 60,
                      color: Palette.darkred,
                    ),
                    top: 10,
                    left: 30,
                  ),
                  Positioned(
                    child: Icon(
                      Icons.question_answer,
                      size: 60,
                      color: Palette.darkred,
                    ),
                    top: 10,
                    left: 150,
                  ),
                  Positioned(
                    child: Icon(
                      Icons.info,
                      size: 60,
                      color: Palette.darkred,
                    ),
                    top: 10,
                    left: 260,
                  )
                ],
              ),
              width: 350,
              height: 78,
            )
          ],
        ),
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
