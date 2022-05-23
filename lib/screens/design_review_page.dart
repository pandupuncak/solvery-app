import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_drive/providers/orders.dart';
import 'dart:async';

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
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 242, 146, 2),
          ),
        ),
        title: Text("Design Inspiration"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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

                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("${document['user_name']}"),
                              //Text(document['timestamp'])
                            ],
                          ),
                          Text(document['review_title']),
                          Text(document['review_text']),
                          Text(document['tukang_name'])
                        ],
                      ),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 170, 217, 255),
                          border: Border.all(
                              color: Color.fromARGB(255, 8, 38, 63),
                              width: 3.0)),
                    );
                  }).toList(),
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
