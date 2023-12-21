import 'package:chat/net/identify.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:chat/net/message.dart';

Future<bool?> showDialog1(BuildContext context, String text) async{
  var res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text(text),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(context, "Yes"),
                child: const Text("确定")),
          ],
        );
      });
}



Future<int> loadingRegister(BuildContext context,String phone,String uname,String passwd) async{
  showDialog(
    context: context,
    barrierDismissible: false, //点击遮罩不关闭对话框
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: Text("正在注册，请不要退出..."),
            )
          ],
        ),
      );
    },
  );

  int res = await register(phone,uname,passwd);
  Navigator.of(context, rootNavigator: true).pop();
  print(res);
  if(res == 1){
    await showDialog1(context, "注册成功");
  }else{
    print("注册失败");
    await showDialog1(context, "注册失败，该手机号已被注册");
  }
  return res;
}


class ShowAwait extends StatefulWidget {
  ShowAwait(this.requestCallback);
  final Future<int> requestCallback;

  @override
  _ShowAwaitState createState() => new _ShowAwaitState();
}

class _ShowAwaitState extends State<ShowAwait> {
  @override
  initState() {
    super.initState();
    new Timer(new Duration(seconds: 1), () {
      widget.requestCallback.then((int onValue) {
        Navigator.of(context).pop(onValue);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }
}

String ReadableTime(String timestamp) {
  List<String> timeList = timestamp.split(" ");
  List<String> times = timeList[1].split(":");
  String time;
  if (new DateTime.now().toString().split(" ")[0] == timeList[0]) {
    if (int.parse(times[0]) < 6) {
      time = "凌晨${times[0]}:${times[1]}";
    } else if (int.parse(times[0]) < 12) {
      time = "上午${times[0]}:${times[1]}";
    } else if (int.parse(times[0]) == 12) {
      time = "中午${times[0]}:${times[1]}";
    } else {
      time =
          "下午${(int.parse(times[0])- 12).toString().padLeft(2,'0')}:${times[1]}";
    }
  } else {
    time = timeList[0];
  }
  return time;
}


void addFriendCallback() {

}


class InputDialog extends StatefulWidget {
  InputDialog({Key? key, this.hintText = "请输入...", this.title = const Text('新的朋友'),required this.me,required this.passwd});
  String me;
  String passwd;
  final Widget? title; // Text('New nickname'.tr)
  final String? hintText;

  @override
  State<InputDialog> createState() => _InputDialogState(title: this.title, hintText: this.hintText,me: me,passwd: passwd);
}

class _InputDialogState extends State<InputDialog> {
  final TextEditingController _textEditingController = TextEditingController();

  final Widget? title; // Text('New nickname'.tr)
  final String? hintText;
  String me;
  String passwd;
  _InputDialogState({required this.title, required this.hintText,required this.me,required this.passwd});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,

      content: TextField(
          controller: _textEditingController,
          maxLength: 12,
          decoration: InputDecoration(hintText: hintText),
          autofocus: false //true 自动弹键盘
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
          onPressed: () async {
            await addFriend(me, _textEditingController.text, passwd);
            Navigator.of(context, rootNavigator: true).pop();
            // Get.back(result: _textEditingController.text);
          },
          child: Text('ok', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              elevation: MaterialStateProperty.all(0)),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            // Get.back();
          },
          child: Text('cancel', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}

Future<String> showInputDialog(BuildContext context,String me,String passwd) async {
  await showDialog(
    barrierDismissible: false, //点击遮罩不关闭对话框
    context: context,
    builder: (BuildContext context) => InputDialog(title: Text("添加好友"),me: me,passwd: passwd,),
  );
  return "test";
}