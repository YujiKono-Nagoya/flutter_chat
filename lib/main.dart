import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/constans/text_style.dart';
import 'package:flutter_chat/firebase_options.dart';
import 'package:flutter_chat/pages/chat_page.dart';
import 'package:flutter_chat/pages/home_page.dart';

void main() async {
  // 初期化処理を追加
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Exercise 2',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(bodyMedium: AppTextStyles.body)),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
