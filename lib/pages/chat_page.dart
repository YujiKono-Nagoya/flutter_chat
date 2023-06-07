import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/constans/text_style.dart';
import 'package:flutter_chat/services/firebase_auth_service.dart';
import 'package:flutter_chat/services/firestore_service.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final userId;
  ChatPage({super.key, required this.userId});

  @override
  // ignore: no_logic_in_create_state
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final _firestoreService = FirestoreService();
  final _messageEditingController = TextEditingController();
  final _listScrollController = ScrollController();
  final double _inputHeight = 60;
  late Stream<QuerySnapshot> _messagesStream;

  Stream<QuerySnapshot> _getMessagesStream() {
    return _firestoreService.getMessagesStream();
  }

  Future<void> _addMessage() async {
    try {
      await _firestoreService.addMessage({
        'text': _messageEditingController.text,
        // millisecondsSinceEpochは1970年1月1日午前0時0分0秒からの経過ミリ秒数
        'date': DateTime.now().millisecondsSinceEpoch,
        'userId': widget.userId,
      });
      _messageEditingController.clear();
      _listScrollController
          .jumpTo(_listScrollController.position.maxScrollExtent);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('メッセージを送信できませんでした'),
        margin: EdgeInsets.only(bottom: _inputHeight),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _messagesStream = _getMessagesStream();
  }

  @override
  void dispose() {
    super.dispose();
    _messageEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: AppTextStyles.title,
        ),
        actions: [
          MaterialButton(onPressed: () {
            FirebaseAuth.instance.signOut();
          })
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> messagesData = snapshot.data!.docs;

                  return Expanded(
                    child: ListView.builder(
                        controller: _listScrollController,
                        itemCount: messagesData.length,
                        itemBuilder: (context, index) {
                          final messageData = messagesData[index].data()
                              as Map<String, dynamic>;
                          return MessageCard(
                            messageData: messageData,
                            commentId: messageData['userId'],
                            userId: widget.userId,
                          );
                        }),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: _inputHeight,
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    controller: _messageEditingController,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                      onPressed: () {
                        if (_messageEditingController.text != '') {
                          _addMessage();
                        }
                      },
                      icon: const Icon(Icons.send)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  MessageCard(
      {Key? key,
      required this.messageData,
      required this.commentId,
      required this.userId})
      : super(key: key);

  final Map<String, dynamic> messageData;
  final commentId;
  final userId;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: commentId == userId ? Colors.purple : Colors.white,
        title: Text(
          messageData['text'] is String ? messageData['text'] : '無効なメッセージ',
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('yyyy/MM/dd HH:mm').format(
                DateTime.fromMillisecondsSinceEpoch(
                  messageData['date'] is int ? messageData['date'] : 0,
                ),
              ),
            ),
            Text('Commenter UID: $commentId'),
          ],
        ),
      ),
    );
  }
}
