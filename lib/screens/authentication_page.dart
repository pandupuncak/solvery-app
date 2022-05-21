import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_drive/providers/authentication.dart';
import 'package:test_drive/screens/registration_page.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Column(
          children: [
            Image.asset('assets/images/logo.png'),
            Text(
              'Tukang.in',
              style: TextStyle(
                color: Color.fromRGBO(197, 79, 0, 1),
                fontFamily: 'DMSans',
                fontSize: 40,
                letterSpacing: -0.3333333432674408,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Color.fromRGBO(249, 247, 183, 1)),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Color.fromRGBO(249, 247, 183, 1)),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<Authentication>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
              },
              child: Text("Sign in"),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(197, 79, 0, 1)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationPage(),
                    ));
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Success"),
                        content: Text("Signed in"),
                      );
                    });
              },
              child: Text("Sign in with Google"),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(135, 101, 234, 0.25)),
              ),
            ),
            RichText(
                text: TextSpan(
              children: [
                TextSpan(
                  text: "You don't have an account yet?",
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Sign up',
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationPage(),
                          ));
                    },
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
