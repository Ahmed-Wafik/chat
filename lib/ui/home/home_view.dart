import 'package:chat_with_friends/model/user.dart';
import 'package:chat_with_friends/ui/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeView extends HomePageState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (item) {
              selectedItem(item);
            },
            itemBuilder: (BuildContext context) => list
                .map((f) => PopupMenuItem<String>(
                      value: f,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          f,
                          style: TextStyle(fontSize: 18, letterSpacing: .5),
                          textAlign: TextAlign.left,
                        ),
                        leading: f == 'profile'
                            ? Icon(
                                Icons.person,
                                size: 30,
                              )
                            : Icon(
                                Icons.exit_to_app,
                                size: 30,
                              ),
                      ),
                    ))
                .toList(),
          )
        ],
      ),
      body: StreamBuilder(
        stream: getStreamSnapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.purple),
              ),
            );
          } else {
            User user;
            return ListView.builder(
              padding: EdgeInsets.only(top: 8),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                user = User.fromJson(snapshot.data.documents[index]);
                if (user.imagePath!=null) {
                  
                return InkWell(
                  onTap: ()=>onItemListTapped(User.fromJson(snapshot.data.documents[index])),
                  child: ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.imagePath),
                    ),
                  ),
                );}
              },
            );
          }
        },
      ),
    );
  }
}
