
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';


Future<String> communication(String _path, Map<String,dynamic> data) async{

  String _text;
  try {
    // Uri uri = Uri(scheme: "http", host: "192.168.1.56", port: 4321,queryParameters: data,path: _path);
    Uri uri = Uri(scheme: "http", host: "81.68.213.251", port: 9001,queryParameters: data,path: _path);
    //创建一个HttpClient
    HttpClient httpClient = HttpClient();
    httpClient.connectionTimeout = Duration(seconds: 2);
    //打开Http连接
    HttpClientRequest request =
    await httpClient.getUrl(uri);
    //使用iPhone的UA
    request.headers.add(
      "user-agent",
      "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1",
    );
    //等待连接服务器（会将请求信息发送给服务器）
    HttpClientResponse response = await request.close();
    //读取响应内容

    _text = await response.transform(utf8.decoder).join();
    //输出响应头


    //关闭client后，通过该client发起的所有请求都会终止。
    httpClient.close();
  } catch (e) {
    _text = "请求失败：$e";
    _text = "0";
  }
  return _text;
}

Future<int> register(String phone,String uname,String passwd) async {
  // // 模拟异步操作
  // String _text;
  // // var bytes = utf8.encode("abcd"); // data being hashed
  // //
  // // var digest = sha256.convert(bytes);
  // //
  // // print("Digest as bytes: ${digest.bytes}");
  // // print("Digest as hex string: $digest");
  // try {
  //   Uri uri = Uri(scheme: "http", host: "192.168.1.59", port: 4321,queryParameters: {
  //     "phone":phone,
  //     "uname":uname,
  //     "passwd":passwd
  //   });
  //   //创建一个HttpClient
  //   HttpClient httpClient = HttpClient();
  //   httpClient.connectionTimeout = Duration(seconds: 2);
  //   //打开Http连接
  //   HttpClientRequest request =
  //   await httpClient.getUrl(uri);
  //   //使用iPhone的UA
  //   request.headers.add(
  //     "user-agent",
  //     "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1",
  //   );
  //   //等待连接服务器（会将请求信息发送给服务器）
  //   HttpClientResponse response = await request.close();
  //   //读取响应内容
  //   _text = await response.transform(utf8.decoder).join();
  //   //输出响应头
  //
  //
  //   //关闭client后，通过该client发起的所有请求都会终止。
  //   httpClient.close();
  // } catch (e) {
  //   _text = "请求失败：$e";
  // }
  // print(_text);

  String _text =   await communication("register",
      {
        "phone":phone,
        "uname":uname,
        "passwd":passwd
      }
  );
  int res = int.parse(_text);
  return res;
  // await Future.delayed(Duration(seconds: 1));
}

Future<int> login(String phone,String passwd) async{
  String _text =   await communication("login",
      {
        "phone":phone,
        "passwd":passwd
      }
  );
  int res = int.parse(_text);
  return res;
}

