import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_drive/providers/palette.dart';
import 'package:test_drive/providers/tukangDetail.dart';
import 'package:test_drive/screens/home_page.dart';

class ReviewPage extends StatefulWidget {
  @override
  const ReviewPage({super.key, required this.reviews});
  final reviewDetail reviews;
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Repair Order';
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
          widget.reviews.tukang_nama,
          style: TextStyle(
            color: Color.fromRGBO(197, 79, 0, 1),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: MyStatefulWidget(
        order_review: widget.reviews,
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key, required this.order_review});

  final reviewDetail order_review;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Form Data
  final TextEditingController title_controller = TextEditingController();
  final TextEditingController review_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Text(
                "Add Review",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Post title",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Write the title of your post here",
                  border: UnderlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                controller: title_controller,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Description",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: "What do you want to talk about?",
                  border: UnderlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true),
              controller: review_controller,
            ),
          ),
          //Padding(padding: EdgeInsets.all(200.0)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: FloatingActionButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('reviews').add({
                      'order_id': widget.order_review.order_id,
                      'tukang_id': widget.order_review.tukang_id,
                      'tukang_name': widget.order_review.tukang_nama,
                      'user_id': FirebaseAuth.instance.currentUser?.uid,
                      'user_name': FirebaseAuth.instance.currentUser?.email,
                      'review_title': title_controller.text,
                      'review_text': review_controller.text,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    Navigator.pushNamed(context, '/home');
                    // MaterialPageRoute(
                    //   builder: (context) => HomePage(),
                    // ));
                  },
                  child: Icon(
                    Icons.send_and_archive,
                    color: Palette.darkred,
                  )),
              alignment: Alignment.center,
            ),
          )
        ]),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Palette.yellow),
      ),
    );
  }
}
