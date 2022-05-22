import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_drive/providers/orders.dart';

class OrdersPage extends StatefulWidget {
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class DynamicItem extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container();
  }
}

class _OrdersPageState extends State<OrdersPage> {
  List<Object> _ordersHistory = [];

  CollectionReference orders =
      FirebaseFirestore.instance.collection('open-orders');

  Future showOrders() async {
    // orders.get().then(
    //   (DocumentSnapshot) {
    //     final orderList = orders.orderBy('timestamp')
    //   }
    // )
    final orderList =
        orders.where("user", isEqualTo: FirebaseAuth.instance.currentUser?.uid);
    // await orders
    //     .where("user", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    //     .orderBy('timestamp', descending: true)
    //     .get()
    //     .then(
    //       (res) => print("Successfully completed"),
    //       onError: (e) => print("Error completing: $e"),
    //     );
    _ordersHistory = orderList as List<Object>;
    // setState(() {
    //   _ordersHistory = List.from(orderList);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        // children: sna,
        );
  }
}
