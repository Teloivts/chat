import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chat/file/localfile-manager.dart';
import 'package:chat/route/sign_in.dart';
import 'dart:async';
import 'dart:io';
void main()
{
    runApp(MyApp());
}

bool _getLoginInfo() {
  getApplicationDocumentsDirectory().then((ret){
      var tmp = new File('$ret/LandingInformation');
      print(tmp.existsSync());
      return tmp.existsSync();
    }
  );
  return false;
}

class MyApp extends StatelessWidget {
  @override Widget build(BuildContext context) {
    var check = _getLoginInfo();
    return MaterialApp(
      title: 'Chat Bubble',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: check ? ChatPage() : new SignIn(),
    );
  }
}
class ChatPage extends StatefulWidget {
  @override _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<String> messages = [];
    TextEditingController _textEditingController = TextEditingController();
    void sendMessage(String message) {
      setState(() { messages.add(message);
        _textEditingController.clear(); });
    }
    @override Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar( title: Text('Chat Bubble'), ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder( itemCount: messages.length,
                itemBuilder: (BuildContext context, int index){
                  return Bubble(
                    message: messages[index],
                    isSent: index % 2 == 0, // Alternate sides for bubbles
                   );
                  },
              ),
            ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration( hintText: 'Type a message...', border: InputBorder.none, ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String message = _textEditingController.text.trim();
                    if (message.isNotEmpty) {
                      sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class Bubble extends StatelessWidget {
  final String message;
  final bool isSent;
  Bubble({required this.message, required this.isSent});
  @override Widget build(BuildContext context) {
      return Container(
        alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSent ? Colors.blue[400] : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
        child: SelectableText(
          message,
          style: TextStyle(
              fontSize: 16,
              color: isSent ? Colors.white : Colors.black,
          ),

        ),
      ),
    );
  }
}