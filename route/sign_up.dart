import 'package:chat/show/prompt_wait.dart';
import 'package:flutter/material.dart';
import 'dart:async';



class SignUp extends StatefulWidget {
  @override
  State createState() => new SignUpState();
}

class SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  // final reference = FirebaseDatabase.instance.reference().child('users');
  bool _correctPhone = true;
  bool _correctUsername = true;
  bool _correctPassword = true;
  bool _correctEmail = true;

  List<String> defaultAvatarList = [
    "portrait-1.png?alt=media&token=ba15c433-0fdd-46fc-a912-05e5a2bbfa47",
    "portrait-2.png?alt=media&token=3e561a09-e19b-47f9-95dc-a89787c3f3a7",
    "portrait-3.png?alt=media&token=e2728607-ed37-415c-baa6-1bf10ba64d0d",
    "portrait-4.png?alt=media&token=d9b130a2-1b33-4728-b356-e7d819550552",
    "portrait-5.png?alt=media&token=5ee20a07-6c95-4d1d-b8b4-5dca5642029f",
    "portrait-6.png?alt=media&token=5139443d-48a9-46f8-9356-bb4a02a5f3cf",
    "portrait-7.png?alt=media&token=908993dc-b591-46af-a680-c01ed0499332",
    "portrait-8.png?alt=media&token=89bd3d6d-8a7f-4249-b0da-a94f49012de7",
    "portrait-9.png?alt=media&token=40660b58-f6ca-4eda-a97a-fd6c749cf55c",
    "portrait-10.png?alt=media&token=13c34b46-834a-485c-afea-4cfe49753021",
    "portrait-11.png?alt=media&token=09906f02-ea1b-4437-960f-1a39d695e5a1",
    "portrait-12.png?alt=media&token=c42a5146-28ff-4097-9b36-e93937edc536",
    "portrait-13.png?alt=media&token=46b3aa5b-ffab-4568-af52-3baea450d99c",
    "portrait-14.png?alt=media&token=68b635fb-693d-4c96-a595-f66c70cf2be0",
    "portrait-15.png?alt=media&token=9fe05ee8-946d-4201-9b96-f06cf50b038f",
    "portrait-16.png?alt=media&token=8bb49cf9-01ec-436d-8d8c-af43e8bcaab3",
    "portrait-17.png?alt=media&token=f049e2ea-03e4-4357-8597-3adc2fc4189f",
    "portrait-18.png?alt=media&token=67cea20b-2bb0-42e2-923c-dc9eaf4fa125",
  ];

  void _handleSubmitted() {
    _checkInput();
    if (_usernameController.text == '' || _passwordController.text == '') {
      //showDialog1(context, "注册信息填写不完整！");
      return;
    } else if (!_correctUsername || !_correctPassword || !_correctPhone) {
      //showDialog1(context, "注册信息的格式不正确！");
      return;
    }

    loadingRegister(context,_phoneController.text,_usernameController.text,_passwordController.text).then(
        (int onValue){

          if(onValue==1){
            print('测试返回');
            Navigator.of(context).pop([_phoneController.text, _passwordController.text]);
          }
        }
    );

  }

  Future<int> _userLogUp(String phone,String username, String password) async {
    return 0;
  }

  static bool isEmail(String input) {
    String regexEmail =
        "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}\$";
    if (input == null || input.isEmpty) return false;
    return new RegExp(regexEmail).hasMatch(input);
  }

  void _checkInput() {
    if (_phoneController.text.isEmpty ||
        (_phoneController.text.trim().length < 7 ||
            _phoneController.text.trim().length > 12)) {
      _correctPhone = false;
    } else {
      _correctPhone = true;
    }
    if (_usernameController.text.isEmpty || _usernameController.text.trim().length > 16) {
      _correctUsername = false;
    } else {
      _correctUsername = true;
    }
    if (_passwordController.text.isEmpty ||
        _passwordController.text.trim().length < 8 ||
        _passwordController.text.trim().length > 16) {
      _correctPassword = false;
    } else {
      _correctPassword = true;
    }
    // if (isEmail(_emailController.text)){
    //   _correctEmail = true;
    // }else{
    //   if(_emailController.text.isNotEmpty){
    //     _correctEmail = false;
    //   }
    //   else{
    //     _correctEmail = true;
    //   }
    // }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: new Stack(children: <Widget>[
          new GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _checkInput();
              },
              child: new Container(
                decoration: new BoxDecoration(),
              )),
          new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new BackButton(),
                new Text(
                  "  注册账户",
                  textScaleFactor: 2.0,
                ),
                new Container(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: new InputDecoration(
                              hintText: '手机号码',
                              errorText: _correctPhone ? null : '号码的长度应该在7到12位之间',
                              icon: new Icon(
                                Icons.phone,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            onSubmitted: (value) {
                              _checkInput();
                            },
                          ),
                          new TextField(
                            controller: _usernameController,
                            decoration: new InputDecoration(
                              hintText: '用户名称',
                              errorText: _correctUsername ? null : '名称的长度应该在1到16位之间',
                              icon: new Icon(
                                Icons.account_circle,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            onSubmitted: (value) {
                              _checkInput();
                            },
                          ),
                          new TextField(
                            controller: _passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                              hintText: '登陆密码',
                              errorText: _correctPassword ? null : '密码的长度应该在8位到16位之间',
                              icon: new Icon(
                                Icons.lock_outline,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            onSubmitted: (value) {
                              _checkInput();
                            },
                          ),
                          // new TextField(
                          //   controller: _emailController,
                          //   keyboardType: TextInputType.emailAddress,
                          //   decoration: new InputDecoration(
                          //     hintText: '电子邮箱（选填）',
                          //     errorText: _correctEmail ? null : '请检查邮箱格式',
                          //     icon: new Icon(
                          //       Icons.email,
                          //       color: Theme.of(context).iconTheme.color,
                          //     ),
                          //   ),
                          //   onSubmitted: (value) {
                          //     _checkInput();
                          //   },
                          // ),
                        ])),
                new Center(
                  child:
                    ElevatedButton(
                      child: Text("注册"),
                      onPressed: _handleSubmitted,
                    ),
                ),
                new Center(
                    child: new FlatButton(
                      child: new Text("已经有账户了？ 登录"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ))
              ])
        ]));
  }
}