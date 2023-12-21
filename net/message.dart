import 'package:chat/net/identify.dart';
import 'package:dio/dio.dart';

Future<String> getFriend(String phone,String passwd) async{
  String res =   await communication("getFriend",
      {
        "phone":phone,
        "passwd":passwd
      }
  );
  return res;
}

Future<String> getMessage(String me,String passwd,String you) async{
  String res =   await communication("getMessage",
      {
        "me":me,
        "passwd":passwd,
        "you": you
      }
  );
  // print(res);
  return res;
}

Future<String> speak(String me,String you,String message,String passwd) async{
  String res =   await communication("speak",
      {
        "speaker":me,
        "listener":you,
        "message":message
      }
  );
  return res;
}

Future<String> addFriend(String me,String you,String passwd) async{
  String res =   await communication("addFriend",
      {
        "me":me,
        "you":you,
        "passwd":passwd
      }
  );
  return res;
}