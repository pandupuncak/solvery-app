import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        title: Text(widget.reviews.tukang_nama),
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
      child: Column(children: [
        Text("Add Review"),
        Text("Post title"),
        Container(
          child: TextFormField(
            decoration: const InputDecoration(
                hintText: "Write the title of your post here"),
            controller: title_controller,
          ),
        ),
        Text("Description"),
        TextFormField(
          decoration: const InputDecoration(
              hintText: "What do you want to talk about?"),
          controller: review_controller,
        ),
        //Padding(padding: EdgeInsets.all(200.0)),
        FloatingActionButton(
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
              color: Colors.white,
            ))
      ]),
    );
  }
}
