// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mouth_cancer/homepage.dart';
import 'package:mouth_cancer/login%20page.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? _errormsg = '';
  final _emailtextcontroller = TextEditingController();

  final _passwordtextcontroller = TextEditingController();
  final _confirmpasscontroller = TextEditingController();
  bool ishidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('assets/lottie/My project-1 (1).png',
                    height: 60),
              ),
              Text(
                'SIGN UP',
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    color: Colors.black26),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: _emailtextcontroller,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.mail,
                          color: Colors.red,
                        ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        hintText: 'email',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: _passwordtextcontroller,
                      textInputAction: TextInputAction.done,
                      obscureText: ishidden,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                ishidden = !ishidden;
                              });
                            },
                            icon: Icon(
                              ishidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.red,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          hintText: 'password'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: _confirmpasscontroller,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          hintText: 'confirm password'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size.fromHeight(50),
                      ),
                      icon: Icon(Icons.lock),
                      label: Text('Register'),
                      onPressed: _regi,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  _regi() async {
    if (_emailtextcontroller.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Email required')));
      return;
    }
    RegExp emailRegExp = RegExp(
        r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegExp.hasMatch(_emailtextcontroller.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email is not valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_passwordtextcontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_confirmpasscontroller.text != _passwordtextcontroller.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailtextcontroller.text.trim(),
          password: _passwordtextcontroller.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errormsg = e.message;
      });
      return;
    }
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }
}
