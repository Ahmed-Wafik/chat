import 'package:chat_with_friends/model/user.dart';
import 'package:chat_with_friends/services/auth_provider.dart';
import 'package:chat_with_friends/ui/chat/chat.dart';
import 'package:chat_with_friends/ui/home/home_view.dart';
import 'package:chat_with_friends/ui/profile/profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onSignOut;

  const HomePage({Key key, this.onSignOut}) : super(key: key);
  HomeView createState() => HomeView();
}

abstract class HomePageState extends State<HomePage> {
  List<String> list = ['profile', 'log out'];

  _navToProfile() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return ProfilePage();
    }));
  }

  getStreamSnapshots() => Firestore.instance.collection('users').snapshots();
  _logOut() => AuthProvider.of(context)
      .auth
      .sigOut()
      .then((_) => widget.onSignOut())
      .catchError(print);

  selectedItem(String item) {
    switch (item) {
      case 'profile':
        _navToProfile();
        break;
      case 'log out':
        _logOut();
        break;
    }
  }

  onItemListTapped(User peerUser) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
          return ChatPage(peerUser: peerUser,);
        }));
  }
}
