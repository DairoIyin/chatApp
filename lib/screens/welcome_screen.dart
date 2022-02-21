import 'package:flutter/material.dart';
import 'package:mi_flash_chat/components/rounded_button.dart';
import 'package:mi_flash_chat/screens/registration_screen.dart';
import 'package:mi_flash_chat/screens/login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(seconds: 3),
      tween: ColorTween(begin: Colors.blueGrey, end: Colors.white),
      //value refers to the tween values
      //child refers to the child of the TweenAnimationBuilder.
      builder: (BuildContext context, Color? value, Widget? child) {
        return Scaffold(
          backgroundColor: value,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Hero(
                tag: 'logo',
                child: Container(
                  height: 60.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Flash Chat',
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 48.0),
          RoundedButton(
              color: Colors.blueAccent,
              title: 'Log in',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              }),
          RoundedButton(
              color: Colors.blueAccent,
              title: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              }),
        ],
      ),
    );
  }
}
