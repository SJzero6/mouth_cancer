import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mouth_cancer/camera.dart';
import 'package:mouth_cancer/homepage.dart';
import 'package:mouth_cancer/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _errormsg = '';
  bool login = true;

  final _emailtextcontroller = TextEditingController();

  final _passwordtextcontroller = TextEditingController();

  bool _showpass = true;

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
                'LOGIN',
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    color: Colors.black26),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    obscureText: _showpass,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showpass = !_showpass;
                              });
                            },
                            icon: Icon(
                              _showpass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.red,
                            )),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        hintText: 'password'),
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
                      label: Text('Sign in'),
                      onPressed: signin),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have account ?',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => Register())));
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 243, 33, 33)),
                      ),
                    )
                  ],
                )
              ]),
            ],
          ),
        ),
      )),
    );
  }

  signin() async {
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

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailtextcontroller.text.trim(),
          password: _passwordtextcontroller.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errormsg = e.message;
      });
      return;
    }
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
  }
}
