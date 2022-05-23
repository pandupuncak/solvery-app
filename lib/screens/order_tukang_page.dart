import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_drive/providers/orderDetail.dart';
import 'package:test_drive/providers/orders.dart';
import 'dart:async';

class TukangsPage extends StatefulWidget {
  const TukangsPage({super.key, required this.order});

  final orderDetail order;
  @override
  State<TukangsPage> createState() => _TukangsPageState();
}

class _TukangsPageState extends State<TukangsPage> {
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
        title: Text("Order #${widget.order.id}"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 211),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('order-tagging')
                  .where('order', isEqualTo: widget.order.id)
                  .where('customer',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('offered_price')
                  .snapshots(),
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
                      //child: Text("${document['tukang']}"),
                      child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('tukang')
                            .doc(document['tukang'])
                            .get(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: LinearProgressIndicator(),
                            );
                          }

                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;

                          return Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 50.0),
                                      child: Text("${data['nama']}"),
                                    ),
                                    Container(
                                      child: Text("${data['category']}"),
                                      alignment: Alignment.topRight,
                                    )
                                  ],
                                  mainAxisSize: MainAxisSize.max,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child:
                                          Text("${document['offered_price']}"),
                                      padding: EdgeInsets.only(right: 40.0),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        "Confirmation Pick"),
                                                    content: Text(
                                                        "Are you sure you want to pick ${data['nama']}?"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text("Yes"),
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'open-orders')
                                                              .doc(widget
                                                                  .order.id)
                                                              .set(
                                                                  {
                                                                'tukang': {
                                                                  'id': document[
                                                                      'tukang'],
                                                                  'nama': data[
                                                                      'nama']
                                                                },
                                                                'status':
                                                                    'tukang selected'
                                                              },
                                                                  SetOptions(
                                                                      merge:
                                                                          true));
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/order');
                                                        },
                                                      ),
                                                      TextButton(
                                                          onPressed: (() =>
                                                              Navigator.pop(
                                                                  context)),
                                                          child: const Text(
                                                              "Cancel"))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: const Text('Pilih Tukang'),
                                        ),
                                        alignment: Alignment.bottomRight,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Color.fromARGB(255, 100, 23, 0))),
                            padding: EdgeInsets.all(30),
                          );

                          // ListView(
                          //     children: snapshot.data!
                          //         .data()!(
                          //           (tukangs) {
                          //             return Row(
                          //               children: [],
                          //             );
                          //           },
                          //         )
                          //         .toList() as List<Widget>);
                        },
                      ),
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border.all(
                      //         color: Colors.deepOrange,
                      //         width: 5.0,
                      //         style: BorderStyle.solid)),
                      // padding: EdgeInsets.all(20.0),
                    );
                  }).toList(),
                );
              }),
        ),
      ),
    );
  }
}
