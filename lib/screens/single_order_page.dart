import 'dart:ffi';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_drive/providers/orders.dart';
import 'package:test_drive/providers/palette.dart';
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
          "Order Progress",
          style: TextStyle(fontWeight: FontWeight.w700, color: Palette.darkred),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Palette.yellow,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('open-orders')
                .where('user',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .orderBy('timestamp', descending: true)
                .limit(1)
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Order ID:",
                          style: TextStyle(
                            color: Palette.darkred,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          document.id,
                          style: TextStyle(
                            color: Palette.darkred,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      //FLOW AWAL
                      if (document['status'] == 'open')
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
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
                        ),

                      //FLOW HABIS MILIH TUKANG
                      if (document['status'] != 'open')
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PIC",
                                style: TextStyle(
                                  color: Palette.darkred,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Tukang: ${document['tukang']['nama']}",
                                  style: TextStyle(
                                    color: Palette.darkred,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      //FLOW HABIS TUKANG DATENG DAN MAU BAYAR
                      if (document['status'] == 'tukang selected')
                        Container(
                          child: ElevatedButton(
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
                          alignment: Alignment.center,
                        ),

                      //FLOW HABIS NGEBAYAR KE TUKANG
                      if (document['status'] == 'project done')
                        Container(
                          child: TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('open-orders')
                                  .doc(document.id)
                                  .set({'status': 'payment confirmed'},
                                      SetOptions(merge: true));
                              setState(() {});
                            },
                            child: Text(
                              "WAITING TUKANG'S CONFIRMATION",
                              style: TextStyle(color: Palette.darkred),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Palette.darkyellow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                        ),

                      //FLOW HABIS TUKANG KONFIRMASI BAYARAN
                      if (document['status'] == 'payment confirmed')
                        Container(
                          child: ElevatedButton(
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
                            child: Text("SHARE REVIEW"),
                          ),
                          alignment: Alignment.center,
                        ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Description",
                          style: TextStyle(
                            color: Palette.darkred,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${document['description']}",
                          style: TextStyle(
                            color: Palette.darkred,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Deadline",
                          style: TextStyle(
                            color: Palette.darkred,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${document['deadline']['value']}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Location",
                          style: TextStyle(
                            color: Palette.darkred,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Longitude: ${document['location']['longitude']}, Latitude ${document['location']['latitude']}",
                          style: TextStyle(
                            color: Palette.darkred,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Cost Range",
                          style: TextStyle(
                            color: Palette.darkred,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Rp.${document['cost']['minimal_cost']} - Rp.${document['cost']['maximal_cost']}",
                          style: TextStyle(
                            color: Palette.darkred,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Order Picture",
                          style: TextStyle(
                            color: Palette.darkred,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<dynamic>(
                            future: _getFromStorage(document['order_image']),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  child: Image.memory(snapshot.data),
                                  //height: 400,
                                  //width: 300,
                                );
                              }
                              return CircularProgressIndicator();
                            }),
                      ), //"gs://solvery-tukangin.appspot.com/${document['order_image']}"
                    ],
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}
