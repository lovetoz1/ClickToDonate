import 'package:donate_to_click/about.dart';
import 'package:donate_to_click/main.dart';
import 'package:donate_to_click/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  String email = "";

  String password = "";
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Center(
            child: Text(
              "Sign in",
              style: style.copyWith(fontSize: 30, color: Colors.deepOrange),
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            children: [
              Center(
                child: Container(
                    height: 300, child: Image.asset('assets/donate2click.png')),
              ),
              TextField(
                obscureText: false,
                style: style,
                onChanged: (value) {
                  email = value;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                style: style,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.deepOrange,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () async {
                    // print(email + " " + password);
                    try {
                      final newuser = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (newuser != null) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MyHomePage(),
                          ),
                          (route) => false,
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.blueAccent,
                        content: Text(
                          '${e.message}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
                    }
                  },
                  child: Text("Sign In",
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Or",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.blueAccent,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RegisterationPage();
                        },
                      ),
                    );
                  },
                  child: Text("Create Account",
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.green,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AboutPage();
                        },
                      ),
                    );
                  },
                  child: Text("How we do this?",
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
