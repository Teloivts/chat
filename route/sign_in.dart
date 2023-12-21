import 'dart:convert';

import 'package:chat/show/prompt_wait.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:chat/route/sign_up.dart';
import 'package:chat/net/identify.dart';
import 'package:chat/route/group_chat.dart';
import 'package:chat/net/message.dart';
import 'package:chat/file/localfile-manager.dart';

class SignIn extends StatefulWidget {
  @override
  State createState() => new _SignInState();
}

class _SignInState extends State<SignIn> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  bool _correctPhone = true;
  bool _correctPassword = true;

  void _handleSubmitted() async {
    _checkInput();
    if (_phoneController.text == '' || _passwordController.text == '') {
      return;
    } else if (!_correctPhone || !_correctPassword) {
      return;
    }
    login(_phoneController.text,_passwordController.text).then((value) async {
      if(value==0){
        showDialog1(context, "登录失败");
      }else if (value == 1) {
        saveLogin(_phoneController.text,_passwordController.text);
        List<dynamic> friends =[];
        var jsonString = await getFriend(_phoneController.text,_passwordController.text);
        friends= jsonDecode(jsonString);
          // print('Howdy, ${user['name']}!');
          // print('We sent the verification link to ${user['email']}.');
        Navigator
            .of(context)
            .push(new MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new MyListView((p0) => null, friends,_phoneController.text,_passwordController.text);
        }));
      }
    });

  }

  Future<int> _userLogIn(String phone, String password) async {
    return 0;
  }



  void _openSignUp() {
    setState(() {
      Navigator.of(context).push(new MaterialPageRoute<List<String>>(
        builder: (BuildContext context) {
          return new SignUp();
        },
      )).then((onValue) {
        if (onValue != null) {
          _phoneController.text = onValue[0];
          _passwordController.text = onValue[1];
          FocusScope.of(context).requestFocus(new FocusNode());
        }
      });
    });
  }

  void _checkInput() {
    if (_phoneController.text.isEmpty ||
        (_phoneController.text.trim().length < 7 ||
            _phoneController.text.trim().length > 12)) {
      _correctPhone = false;
    } else {
      _correctPhone = true;
    }
    if (_passwordController.text.isEmpty ||
        _passwordController.text.trim().length < 6) {
      _correctPassword = false;
    } else {
      _correctPassword = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
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
              new Center(
                  child: new Image.asset(
                    'images/talk_casually.png',
                    width: MediaQuery.of(context).size.width * 0.3,
                  )),
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
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            hintText: '登陆密码',
                            errorText: _correctPassword ? null : '密码的长度应该大于6位',
                            icon: new Icon(
                              Icons.lock_outline,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          onSubmitted: (value) {
                            _checkInput();
                          },
                        ),
                      ])),
              new Center(
                child: new  ElevatedButton(
                  child: Text("登录"),
                  onPressed: _handleSubmitted,
                ),
              )
              ,
              new Center(
                  child: new FlatButton(
                    child: new Text("没有帐户？ 注册"),
                    onPressed: _openSignUp,
                  ))
            ],
          )
        ]));
  }
}

