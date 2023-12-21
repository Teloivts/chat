import 'dart:async';
import 'dart:convert';

import 'package:chat/net/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Talk extends StatefulWidget {
  String me;
  String you;
  String passwd;
  String data;
  Talk(this.me,this.you,this.passwd,this.data){
  }


  @override
  State createState() {
    return new _TalkState(me,you,passwd,data);
  }
}


class _TalkState extends State<Talk> {
  int _num = 0;
  ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  String me;
  String you;
  String passwd;
  String jsonData;
  _TalkState(this.me,this.you,this.passwd,this.jsonData){
    List<dynamic> data = jsonDecode(jsonData);
    data.forEach((element) {
      messages.add(new Message(element[0],element[1], element[2]));
    });


  }
  TextEditingController _textEditingController = TextEditingController();
  String getTime(){
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;
    int hour = now.hour;
    int minute = now.minute;
    int second = now.second;

    return '$year-$month-$day $hour:$minute:$second';
  }
  void sendMessage(String text) {
    speak(me, you, text, passwd);
    _textEditingController.clear();

    setState((){
      messages.add(new Message(text,me, you));
    });

    Future.delayed(Duration(milliseconds: 300), () {

      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }
  @override Widget build(BuildContext context) {

    Timer.periodic(
        Duration(seconds: 2),
            (timer) {
          getMessage(me, passwd, you).then(
                (value) {
                _num++;
                // print(value);
                List<dynamic> data = jsonDecode(value);
                // print(_num);
                // print(messages.length);
                // print(data);
                if (data.length > messages.length) {
                  messages.clear();
                  data.forEach((element) {
                    messages.add(new Message(element[0],element[1], element[2]));
                  });
                  setState(() {
                  });
                  //   print('更新数据');
                }
              }


          );
        }
    );


    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });//让焦点初始化列表时就在底部
    return Scaffold(
      appBar: AppBar( title: Text('纸聊'), ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index){
                    return messages[index].me == me ? _renderRowSendByMe(context, messages[index]) : _renderRowSendByOthers(context, messages[index]);
                // return Bubble(
                //   message: messages[index].text,
                //   isSent: messages[index].me == me, // Alternate sides for bubbles
                // );
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

class Message{
  String text;
  String me;
  String you;
  Message(this.text,this.me,this.you);
}

Widget _renderRowSendByOthers(BuildContext context, Message item) {
  return Container(
    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
    child: Column(
      children: <Widget>[
        Padding(
          // child: Text(
          //   CommonUtils.timeStampFormat(item['createdAt']),
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: Color(0xFFA1A6BB),
          //     fontSize: 14,
          //   ),
          // ),
          padding: EdgeInsets.only(bottom: 20),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 45),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Color(0xFF464EB5),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  child: Text(
                    item.me.toString().substring(0, 1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: 2),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      child: Text(
                        item.me,
                        softWrap: true,
                        style: TextStyle(
                          color: Color(0xFF677092),
                          fontSize: 14,
                        ),
                      ),
                      padding: EdgeInsets.only(left: 20, right: 30),
                    ),
                    Stack(
                      children: <Widget>[
                        // Container(
                        //   child: Image(
                        //       width: 11,
                        //       height: 20,
                        //       image: AssetImage(
                        //           "static/images/chat_white_arrow.png")),
                        //   margin: EdgeInsets.fromLTRB(2, 16, 0, 0),
                        // ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(4.0, 7.0),
                                  color: Color(0x04000000),
                                  blurRadius: 10,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          margin: EdgeInsets.only(top: 8, left: 10),
                          padding: EdgeInsets.all(10),
                          child: SelectableText(
                            item.text,
                            style: TextStyle(
                              color: Color(0xFF03073C),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _renderRowSendByMe(BuildContext context,Message item) {
  var contentMaxWidth = MediaQuery.of(context).size.width - 90;
  return Container(
    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
    child: Column(
      children: <Widget>[
        Padding(
          // child: Text(
          //   CommonUtils.timeStampFormat(item['createdAt']),
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: Color(0xFFA1A6BB),
          //     fontSize: 14,
          //   ),
          // ),
          padding: EdgeInsets.only(bottom: 20),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 15),
              alignment: Alignment.center,
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: Color(0xFF464EB5),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                child: Text(
                  item.me.toString().substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                padding: EdgeInsets.only(bottom: 2),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  child: Text(
                    item.me,
                    softWrap: true,
                    style: TextStyle(
                      color: Color(0xFF677092),
                      fontSize: 14,
                    ),
                  ),
                  padding: EdgeInsets.only(right: 20),
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    // Container(
                    //   child: Image(
                    //       width: 11,
                    //       height: 20,
                    //       image: AssetImage(
                    //           "static/images/chat_purple_arrow.png")),
                    //   margin: EdgeInsets.fromLTRB(0, 16, 2, 0),
                    // ),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        ConstrainedBox(
                          child: Container(
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(4.0, 7.0),
                                    color: Color(0x04000000),
                                    blurRadius: 10,
                                  ),
                                ],
                                color: Color(0xFF838CFF),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            padding: EdgeInsets.all(10),
                            child: SelectableText(
                              item.text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: contentMaxWidth,
                          ),
                        )

                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    ),
  );
}
