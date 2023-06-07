import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final userId;
  final email;
  const Home({super.key, required this.userId, required this.email});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [Text('${widget.userId}がログインしています'), Text('${widget.email}')],
      ),
    );
  }
}
