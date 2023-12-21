import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:chat/net/message.dart';
import 'package:chat/route/talk.dart';
import 'package:chat/show/prompt_wait.dart';
import 'package:badges/badges.dart' as badges;

class MyListView extends StatefulWidget {

  Function(int) onItemTap;
  List<dynamic> bookshelf = [];
  String phone;
  String passwd;
  MyListView(this.onItemTap,List<dynamic> x,this.phone,this.passwd) {
    bookshelf = x;
    print(bookshelf);
  }

  @override
  _MyListViewState createState() => _MyListViewState(bookshelf,phone,passwd);
}

class _MyListViewState extends State<MyListView> {
  List<dynamic> bookshelf = [];
  String phone;
  String passwd;

  _MyListViewState(List<dynamic> x,this.phone,this.passwd){
    bookshelf = x;
  }

  int _selectedIndex = -1;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar( 
      //   title: Text('纸聊'), 
      //   leading: IconButton(
      //         icon: Icon(Icons.arrow_back),
      //           onPressed: () {
      //             print("右侧按钮的图标");
      //             Navigator.of(context).pop();
      //           },
      //         ),
        
      //     actions: [
      //       badges.Badge(
      //         badgeContent: Text('3'),
      //         child: IconButton(
      //         icon: const Icon(Icons.mail_outline),
      //           onPressed: () {
      //             print("右侧按钮的图标1");
      //           },
      //         ),
      //       ),

      //       badges.Badge(
      //         child: IconButton(
      //         icon: const Icon(Icons.settings),
      //           onPressed: () {
      //             print("右侧按钮的图标2");
      //           },
      //         ),
      //       ),
      //     ]
      // ),
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       print("右侧按钮的图标");
        //       Navigator.of(context).pop();
        //     },
        // ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('纸聊'),
          ],
        ),
        actions:[
          Row(
            children: [
            //               badges.Badge(
            //   badgeContent: Text('1'),
            //   child: IconButton(
            //     icon: Icon(Icons.mail_outline),
            //     onPressed: () {
            //       print('mail');
            //       // 点击操作
            //     },
            //   ),
            // ),
            IconButton(
              icon: const Icon(Icons.settings),
                onPressed: () {
                  print("settings");
                },
              )
            ],
          )
        ]
      ),
      body: ListView.separated(
        itemCount: bookshelf.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: Colors.blue,);
        },
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // print(phone);
              // print(bookshelf[index]);
              getMessage(phone, passwd, bookshelf[index][0]).then(
                      (value){
                        Navigator
                            .of(context)
                            .push(new MaterialPageRoute<Null>(builder: (BuildContext context) {

                          return new Talk(phone,bookshelf[index][0],passwd,value);
                        }));
                      }
              );
              // widget.onItemTap(index);

              setState(() {
                if( index != _selectedIndex){
                  _selectedIndex = index;
                }else{
                  _selectedIndex = -1;
                }

              });
              //onItemTap(_items[index]);
            },
            child: ListTile(
              title: Text(
                bookshelf[index][1],
                style: TextStyle(
                  fontWeight: index==_selectedIndex ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.blue,
          elevation: 0.0,
          onPressed: () async {
            await showInputDialog(context,phone,passwd);
            var jsonString = await getFriend(phone,passwd);
            print(jsonString);
            bookshelf= jsonDecode(jsonString);
            setState(() {

            });
          },
          child: new Icon(Icons.person_add)),
    );
  }

}
