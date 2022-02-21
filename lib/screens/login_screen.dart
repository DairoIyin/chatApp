import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mi_flash_chat/components/rounded_button.dart';
import 'package:mi_flash_chat/constants.dart';
import 'package:mi_flash_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email = '';
  String password = '';
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Container(
                        height: 200.0,
                        child: Image.asset('images/logo.png'),
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your email'),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: true,
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your Password'),
                    ),
                    RoundedButton(
                      color: Colors.blueAccent,
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final User = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (User != null) {
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                        } catch (e) {
                          print(e);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      title: 'Log In',
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
