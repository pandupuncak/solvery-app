import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class RepairPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Repair Order';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
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
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedValue = "Electrician";
  @override
  final storageref = FirebaseStorage.instance.ref();
  // final imagesRef = storageref.child("images");
  // final orderImgRef = storageref.child("images/orders/");

  File? _photo;

  Future UploadFile() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute}/path/to/mountains.jpg";
    final file = File(filePath);

    // Create the file metadata
    final metadata = SettableMetadata(contentType: "image/jpeg");

    // Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

    // Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child("images/path/to/mountains.jpg")
        .putFile(file, metadata);

    // Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          // Handle successful uploads on complete
          // ...
          break;
      }
    });
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Category"),
          DropdownButtonFormField<String>(
            value: selectedValue,
            items: <String>['Electrician', 'Pipa', 'Bangunan', 'Cat']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
          ),
          Text("Description"),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Describe your problem',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Text("Cost Range"),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Minimal",
                  ),
                ),
              ),
              Text("S/D"),
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Maksimal",
                  ),
                ),
              ),
            ],
          ),
          Text("Work Location"),
          TextFormField(
            decoration: const InputDecoration(hintText: "LocationStandIn"),
          ),
          Text("Deadline"),
          DateTimeFormField(
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.event_note),
              labelText: 'Only time',
            ),
            mode: DateTimeFieldPickerMode.time,
            autovalidateMode: AutovalidateMode.always,
            validator: (e) =>
                (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
            onDateSelected: (DateTime value) {
              print(value);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  // Process data.
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

// class RepairPage extends StatefulWidget {
//   @override
//   State<RepairPage> createState() => _RepairPageState();
// }

// class _RepairPageState extends State<RepairPage> {
//   @override
//   Widget build(BuildContext context) {
//     String dropdownValue = 'Electrician';
//     return Center(
//       child: Scaffold(
//         appBar: new AppBar(
          // leading: InkWell(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: Icon(
          //     Icons.arrow_back,
          //     color: Color.fromARGB(255, 242, 146, 2),
          //   ),
//           ),
//         ),
//         body: Column(children: [
//           Text("Category"),
//           DropdownButton<String>(
//             value: dropdownValue,
//             items: <String>['Electrician', 'Pipa', 'Bangunan', 'Cat']
//                 .map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             onChanged: (String? newValue) {
//               setState(() {
//                 dropdownValue = newValue!;
//               });
//             },
//           ),
//           Text('Description'),
          
//         ]),
//       ),
//     );
//   }
// }
