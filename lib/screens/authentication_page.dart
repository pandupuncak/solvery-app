import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_drive/providers/authentication.dart';
import 'package:test_drive/providers/palette.dart';
import 'package:test_drive/screens/registration_page.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Image.asset('assets/images/logo.png'),
              Text(
                'Tukang.in',
                style: TextStyle(
                  color: Palette.darkred,
                  fontFamily: 'DM Sans',
                  fontSize: 40,
                  letterSpacing: -0.3333333432674408,
                  fontWeight: FontWeight.w700,
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
                    fillColor: Color.fromRGBO(249, 247, 183, 1),
                    focusColor: Color.fromARGB(255, 15, 72, 17)),
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
                  Navigator.pushNamed(context, '/home');
                },
                child: Text("LOGIN"),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  // backgroundColor: MaterialStateProperty.all<Color>(
                  //     Color.fromRGBO(197, 79, 0, 1)),
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
                child: Text("SIGN IN WITH GOOGLE"),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Palette.darkyellow),
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
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
