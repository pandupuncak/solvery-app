import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_drive/providers/authentication.dart';

class RegistrationPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController NameController = TextEditingController();
  final TextEditingController LocationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: new AppBar(
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
        body: Column(
          children: [
            Image.asset('assets/images/logo.png'),
            Text(
              'Tukang.in',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(197, 79, 0, 1),
                fontFamily: 'DM Sans',
                fontSize: 40,
                letterSpacing: -0.3333333432674408,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
            Text(
              'Put your details here: ',
              style: TextStyle(
                color: Color.fromRGBO(197, 79, 0, 1),
                fontFamily: 'SourceSansPro',
                fontSize: 20,
                letterSpacing: -0.3333333432674408,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
            TextField(
              controller: NameController,
              decoration: InputDecoration(
                labelText: "Your Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Color.fromRGBO(249, 247, 183, 1),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Color.fromRGBO(249, 247, 183, 1),
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Color.fromRGBO(249, 247, 183, 1),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<Authentication>().signUp(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Success"),
                        content: Text("User registered"),
                      );
                    });
              },
              child: Text("Sign Up"),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
