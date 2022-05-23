import 'dart:ffi';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_drive/providers/orders.dart';
import 'package:test_drive/providers/tukangDetail.dart';
import 'dart:async';
import 'dart:io';

import 'package:test_drive/screens/order_tukang_page.dart';
import 'package:test_drive/screens/review_page.dart';

import '../providers/orderDetail.dart';

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

  final ref = FirebaseStorage.instance.ref();

  String? photourl;

  _getFromStorage(String url) async {
    final imageref = ref.child(url);

    try {
      const oneMegabyte = 1024 * 1024;
      final data = await imageref.getData(oneMegabyte);
      return data;
    } on FirebaseException catch (e) {
      print("error loading images");
    }
  }

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
        title: Text("Order Progress"),
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
                    final image = _getFromStorage(document['order_image']);

                    //ORDERS BUAT NYARI TUKANG
                    final orders = orderDetail(
                        document.id,
                        document['category'],
                        document['cost']['minimal_cost'],
                        document['cost']['maximal_cost'],
                        document['location']['value'],
                        document['deadline']['value']);

                    //ORDERS BUAT REVIEW

                    // //State Kendali

                    // //Pengecekan Tukang
                    // Map checkMap = document.data() as Map<String, dynamic>;
                    // bool noTukang = !checkMap.containsKey('tukang');
                    // // try {
                    // //   if (document['tukang'] != null) {
                    // //     final noTukang = false;
                    // //   }
                    // // } on Exception catch (e) {
                    // //   print("Bad request");
                    // // }

                    return Container(
                        child: Column(
                      children: [
                        Text("ID: ${document.id}"),

                        //FLOW AWAL
                        if (document['status'] == 'open')
                          ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('order-tagging')
                                  .add({
                                "order": document.id,
                                "customer":
                                    FirebaseAuth.instance.currentUser?.uid,
                                "tukang": "M8Bxlsguvu4wrsQCKbnY",
                                "offered_price": "1000",
                              });
                              FirebaseFirestore.instance
                                  .collection('order-tagging')
                                  .add({
                                "order": document.id,
                                "customer":
                                    FirebaseAuth.instance.currentUser?.uid,
                                "tukang": "SO96oKLVjcr2QU0wGDYs",
                                "offered_price": "2000",
                              });
                              FirebaseFirestore.instance
                                  .collection('order-tagging')
                                  .add({
                                "order": document.id,
                                "customer":
                                    FirebaseAuth.instance.currentUser?.uid,
                                "tukang": "38wndgKsHUfHb46uIW8X",
                                "offered_price": "2500",
                              });
                              FirebaseFirestore.instance
                                  .collection('order-tagging')
                                  .add({
                                "order": document.id,
                                "customer":
                                    FirebaseAuth.instance.currentUser?.uid,
                                "tukang": "UxjdK31GhbhFQVhbfBHQ",
                                "offered_price": "3000",
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TukangsPage(order: orders),
                                ),
                              );
                            },
                            child: Text("SELECT TUKANG"),
                          ),

                        //FLOW HABIS MILIH TUKANG
                        if (document['status'] != 'open')
                          Column(
                            children: [
                              Text("PIC"),
                              Text("Tukang: ${document['tukang']}"),
                            ],
                          ),

                        //FLOW HABIS TUKANG DATENG DAN MAU BAYAR
                        if (document['status'] == 'tukang selected')
                          TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('open-orders')
                                  .doc(document.id)
                                  .set({'status': 'project done'},
                                      SetOptions(merge: true));
                              setState(() {});
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             new SingleOrderPage()));
                            },
                            child: Text('PROCESS PAYMENT'),
                          ),

                        //FLOW HABIS NGEBAYAR KE TUKANG
                        if (document['status'] == 'project done')
                          TextButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('open-orders')
                                    .doc(document.id)
                                    .set({'status': 'payment confirmed'},
                                        SetOptions(merge: true));
                                setState(() {});
                              },
                              child: Text("WAITING TUKANG'S CONFIRMATION")),

                        //FLOW HABIS TUKANG KONFIRMASI BAYARAN
                        if (document['status'] == 'payment confirmed')
                          TextButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('open-orders')
                                    .doc(document.id)
                                    .set({'status': 'on review'},
                                        SetOptions(merge: true));
                                final review = reviewDetail(
                                    document.id,
                                    document['tukang']['id'],
                                    document['tukang']['nama']);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReviewPage(reviews: review)));
                              },
                              child: Text("SHARE REVIEW")),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              Text("Description: ${document['description']}"),
                        ),
                        Text("Deadline"),
                        Text("${document['deadline']['value']}"),
                        Text("Location"),
                        Text("${document['location']['value']}"),
                        Text("Cost Range"),
                        Text(
                            "${document['cost']['minimal_cost']} - ${document['cost']['maximal_cost']}"),
                        Text("Order Picture"),
                        FutureBuilder<dynamic>(
                            future: _getFromStorage(document['order_image']),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  child: Image.memory(snapshot.data),
                                  height: 400,
                                  width: 300,
                                );
                              }
                              return CircularProgressIndicator();
                            }), //"gs://solvery-tukangin.appspot.com/${document['order_image']}"
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
