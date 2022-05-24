import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:test_drive/providers/palette.dart';

class RepairPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Repair Order';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.yellow,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 242, 146, 2),
            ),
          ),
          title: Text(
            "Repair Order",
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class _orderForm {
  String? category;
  String? description;
  int? minimal_cost;
  int? maximal_cost;
  String? location;
  String? day;
  String? month;
  String? year;
  String? pathtoPhoto;
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Form Data
  final TextEditingController category_controller = TextEditingController();
  final TextEditingController desc_controller = TextEditingController();
  final TextEditingController mincost_controller = TextEditingController();
  final TextEditingController maxcost_controller = TextEditingController();
  double longitude_controller = 0;
  double latitude_controller = 0;
  DateTime? deadline;

  String selectedValue = "Electrician";
  @override
  final storageref = FirebaseStorage.instance.ref();
  // final imagesRef = storageref.child("images");
  // final orderImgRef = storageref.child("images/orders/");

  // PHOTO UPLOADS

  File? _photo;

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _photo = imageFile;
    }
    print(_photo?.path);
    _addImageWidget();
    UploadFile();
  }

  UploadFile() async {
    final appDocDir = _photo; //await getApplicationDocumentsDirectory();
    final filePath = "images/${appDocDir}.jpg";
    final file = File(filePath);

    // Create the file metadata
    final metadata = SettableMetadata(contentType: "image/jpeg");

    // Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

    // Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef.child(filePath).putFile(appDocDir!, metadata);

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

  List<Widget> _imageList = [];

  void _addImageWidget() {
    setState(() {
      _imageList.add(_image());
    });
  }

  Widget _image() {
    return Image.file(_photo!);
  }

  //LOCATION GETTERS
  GoogleMapController? _controller;
  Marker? _point;
  LocationData? locationSent;
  Location currentLocation = Location();
  Set<Marker> _markers = {};
  void getLocation() async {
    var location = await currentLocation.getLocation();
    currentLocation.onLocationChanged.listen((LocationData loc) {
      _controller
          ?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: 12.0,
      )));
      // print(loc.latitude);
      locationSent = loc;
      longitude_controller = loc.longitude!;
      latitude_controller = loc.latitude!;
      // print(loc.longitude);
      setState(() {
        _markers.clear();
        _markers.add(Marker(
            markerId: MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
      });
    });
  }

  void _addMarker(LatLng pos) {
    setState(
      () {
        _point = null;
        _markers.clear();
        _point = Marker(
          markerId: const MarkerId('point'),
          infoWindow: const InfoWindow(title: 'point'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: pos,
        );
        _markers.add(_point!);
        print(pos.longitude);
        longitude_controller = pos.longitude;
        latitude_controller = pos.latitude;
      },
    );
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Palette.yellow),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Category",
                  style: TextStyle(
                    color: Palette.darkred,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedValue,
                  items: <String>[
                    'Electrician',
                    'Waterworks',
                    'Buildings',
                    'Paint'
                  ].map<DropdownMenuItem<String>>((String value) {
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
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.white),
                  style: TextStyle(
                      color: Palette.darkred,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Description",
                  style: TextStyle(
                    color: Palette.darkred,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Describe your problem',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(197, 79, 0, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  controller: desc_controller,
                  style: TextStyle(
                    color: Palette.darkred,
                    fontWeight: FontWeight.w500,
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Minimal",
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(197, 79, 0, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        controller: mincost_controller,
                        style: TextStyle(
                          color: Palette.darkred,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "S/D",
                        style: TextStyle(
                          color: Palette.darkred,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Maksimal",
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(197, 79, 0, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        style: TextStyle(
                          color: Palette.darkred,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        controller: maxcost_controller,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Work Location",
                  style: TextStyle(
                    color: Palette.darkred,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Container(
                      height: 400,
                      width: 500,
                      child: GoogleMap(
                        zoomControlsEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(-6.890450, 107.610406),
                          zoom: 10.0,
                        ),
                        onMapCreated: (controller) => _controller,
                        markers: _markers,
                        onLongPress: _addMarker,
                      ),
                    ),
                    FloatingActionButton(
                      child: Icon(
                        Icons.location_searching,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        getLocation();
                      },
                    )
                  ],
                ),
              ),
              //Text("$longitude_controller"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Deadline",
                  style: TextStyle(
                    color: Palette.darkred,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              DateTimeFormField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(197, 79, 0, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'Only day',
                  fillColor: Colors.white,
                  filled: true,
                ),
                dateTextStyle: TextStyle(
                  color: Palette.darkred,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                mode: DateTimeFieldPickerMode.date,
                autovalidateMode: AutovalidateMode.always,
                validator: (e) =>
                    (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                onDateSelected: (DateTime value) {
                  print(value);
                  deadline = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Upload photo",
                  style: TextStyle(
                    color: Palette.darkred,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        child: Icon(
                          Icons.upload_sharp,
                          size: 60,
                        ),
                        onTap: () {
                          _getFromGallery();
                          // print(_photo?.path);
                          // _addImageWidget();
                          //UploadFile();
                        },
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Container(
                      child: SizedBox(
                        height: 100,
                        width: 200,
                        child: ListView.builder(
                          itemCount: _imageList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) {
                            return _imageList[index];
                          }),
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Palette.darkred,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(10),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Success"),
                            content: SingleChildScrollView(
                              child: ListBody(children: const <Widget>[
                                Text(
                                    "After you submit, you won't be able to edit your order"),
                                Text("Publish your order?")
                              ]),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Yes"),
                                onPressed: (() {
                                  if (_formKey.currentState!.validate()) {
                                    // Process data.
                                    FirebaseFirestore.instance
                                        .collection('open-orders')
                                        .add({
                                      "timestamp": DateTime.now().toString(),
                                      "user": FirebaseAuth
                                          .instance.currentUser?.uid,
                                      "user_name": FirebaseAuth
                                          .instance.currentUser?.displayName,
                                      "category": selectedValue,
                                      "description": desc_controller.text,
                                      "cost": {
                                        "minimal_cost": mincost_controller.text,
                                        "maximal_cost": maxcost_controller.text,
                                      },
                                      "location": {
                                        "value": locationSent.toString(),
                                        "longitude": longitude_controller,
                                        "latitude": latitude_controller
                                      },
                                      "deadline": {
                                        "value": deadline?.toString(),
                                        "day": deadline?.day,
                                        "month": deadline?.month,
                                        "year": deadline?.year
                                      },
                                      "order_image": "images/${_photo}.jpg",
                                      "status": "open",
                                    });
                                    Navigator.pushNamed(context, '/order');
                                  }
                                }),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        });
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                  },
                  child: const Text('Publish Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
