import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_drive/providers/orders.dart';
import 'dart:async';

import 'package:test_drive/providers/palette.dart';

class DesignReviewPage extends StatefulWidget {
  @override
  State<DesignReviewPage> createState() => _DesignReviewPageState();
}

class DynamicItem extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container();
  }
}

class _DesignReviewPageState extends State<DesignReviewPage> {
  List<Object> _ordersHistory = [];

  CollectionReference orders =
      FirebaseFirestore.instance.collection('open-orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.yellow,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Palette.darkred,
          ),
        ),
        title: Text(
          "Design Inspiration",
          style: TextStyle(
            color: Color.fromRGBO(197, 79, 0, 1),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('reviews').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Container(
                  child: ListView(
                    children: snapshot.data!.docs.map((document) {
                      return Column(
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "${document['user_name']}",
                                    style: TextStyle(
                                      color: Color.fromRGBO(197, 79, 0, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Palette.yellow,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25))),
                                  alignment: Alignment.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    document['review_title'],
                                    style: TextStyle(
                                      color: Color.fromRGBO(197, 79, 0, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    document['review_text'],
                                    style: TextStyle(
                                      color: Color.fromRGBO(197, 79, 0, 1),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "Tukang: ",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(197, 79, 0, 1),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            )),
                                        TextSpan(
                                            text: "${document['tukang_name']}",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(197, 79, 0, 1),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            )),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Palette.yellow,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    ),
                                  ),
                                  width: 390,
                                ),
                              ],
                            ),
                            //rpadding: EdgeInsets.symmetric(vertical: 15.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // border: Border.all(
                                //   //color: Color.fromARGB(255, 8, 38, 63),
                                //   //width: 3.0,
                                // ),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          SizedBox(height: 25),
                        ],
                      );
                    }).toList(),
                  ),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Palette.lightyellow),
                );
              }),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => AddView(),
      //       ),
      //     );
      //   },
      //   backgroundColor: Colors.blue,
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
    );
  }
}
