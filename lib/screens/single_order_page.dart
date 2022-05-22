import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_drive/providers/orders.dart';
import 'dart:async';

class SingleOrderPage extends StatefulWidget {
  @override
  State<SingleOrderPage> createState() => _SingleOrderPageState();
}

class DynamicItem extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container();
  }
}

class _SingleOrderPageState extends State<SingleOrderPage> {
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
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('open-orders')
                  .where('user',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('timestamp', descending: true)
                  .limit(1)
                  .get(),
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
                        ElevatedButton(
                            onPressed: () {}, child: Text("SELECT TUKANG")),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              Text("Description: ${document['description']}"),
                        ),
                        Text("Deadline"),
                        Text("${document['deadline']['value']}"),
                        Text("Location"),
                        Text("${document['location']}"),
                        Text("Cost Range"),
                        Text(
                            "${document['cost']['minimal_cost']} - ${document['cost']['maximal_cost']}"),
                        Text("Order Picture")
                      ],
                    ));
                  }).toList(),
                );
              }),
        ),
      ),
    );
  }
}
