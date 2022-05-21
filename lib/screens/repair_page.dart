import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
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
