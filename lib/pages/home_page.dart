import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/chat_page.dart';
import 'package:flutter_chat/pages/home_page_2.dart';
import 'package:flutter_chat/pages/sign_up.dart';
import 'package:flutter_chat/services/firebase_auth_service.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSignedIn = false;
  String email = '';
  String userId = '';

  void checkSignInState() {
    FirebaseAuthService().authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          _isSignedIn = false;
        });
      } else {
        userId = user.uid;
        email = user.email!;
        setState(() {
          _isSignedIn = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkSignInState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isSignedIn
          ? ChatPage(
              userId: userId,
            )
          : const SignUp(),
    );
  }
}
