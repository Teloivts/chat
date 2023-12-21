
import 'dart:convert';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalFileManager {

  Future<String?> get_localPath() async {
    final dir = await getExternalStorageDirectory();
    print(dir?.path);
    return dir?.path;
  }


  Future<List<String>> getLocalComicDirectory() async {
    final directory = await getExternalStorageDirectory();
    //print(directory?.path);
    final allEntities = directory?.listSync();
    final directories = allEntities
        ?.where((entity) => entity is Directory)
        .map((directory) => directory.path)
        .toList();
    directories?.sort(compare);
    for(var a in directories!){
      //print(a);
    };
    return directories;
  }
  static int compare(String a, String b){
    if(a.length==b.length){
      return a.compareTo(b);
    }
    return a.length.compareTo(b.length);
  }
  Future<List<String>> getLocalComicDetail(String dir) async {
    //print(dir);
    var target = Directory(dir);///storage/emulated/0/Android/data/com.example.my_ebook/files/strategic-lovers-chapter-23/26.rawkuma.com.jpg
    final allEntities = target.listSync();
    final directories = allEntities
        .where((entity) => !(entity is Directory))
        .map((directory) => directory.path)
        .toList();
    directories.sort(compare);
    // for(var a in directories){
    //   print(a);
    // };
    return directories;

    //print(directory?.path);

  }

  static Future<String?> get_loginInformation() async{
    final directory = await getExternalStorageDirectory();
    print(directory);
    return "1234";
  }


}

Future<Null> saveLogin(String phone, String passwd) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  await new File('$dir/LandingInformation').writeAsString(
      '{"phone":"$phone","name":"$passwd"}');
}

Future<Map> readLoginData() async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$dir/LandingInformation');
  String data = await file.readAsString();
  Map json = new JsonDecoder().convert(data);
  return json;
}