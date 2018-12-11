import 'package:chat_with_friends/model/user.dart';
import 'package:chat_with_friends/services/auth_provider.dart';
import 'package:chat_with_friends/ui/home/home.dart';
import 'package:chat_with_friends/ui/registration/registration.dart';
import 'package:flutter/material.dart';

class RoutePage extends StatefulWidget {
  _RoutePageState createState() => _RoutePageState();
}

enum AuthStatus { notSignIn, signIn }

class _RoutePageState extends State<RoutePage> {
  AuthStatus authStatus = AuthStatus.notSignIn;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var auth = AuthProvider.of(context).auth;
    auth.currentUser().then((userID) {
      setState(() {
        authStatus = userID == null ? AuthStatus.notSignIn : AuthStatus.signIn;
      });
    });
  }

  _signIn() {
    setState(() {
      authStatus = AuthStatus.signIn;
    });
  }

  _signOut() {
    setState(() {
      authStatus = AuthStatus.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignIn:
        return LogInPage(onSignIn: _signIn);
      case AuthStatus.signIn:
        return HomePage(
          onSignOut: _signOut,
        );
    }
    return null;
  }
}
