import 'package:chat_with_friends/model/user.dart';
import 'package:chat_with_friends/services/auth_provider.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PROFILE'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: AuthProvider.of(context).auth.userInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              User user = User.fromJson(snapshot.data);
              return _buildProfile(context, user);
            }
          },
        ));
  }

  _buildProfile(context, User user) => Center(
          child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: NetworkImage(user.imagePath)),
                  ),
            ),
            
            Container(
             width: double.infinity,
             color: Colors.blue,
             height: 60,
             alignment: Alignment.center,
              child: Text(
                user.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  letterSpacing: 2
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ));
}
