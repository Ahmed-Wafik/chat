import 'package:chat_with_friends/services/firebase_services.dart';
import 'package:flutter/material.dart';

class AuthProvider extends InheritedWidget {
  final BaseAuth auth;
  AuthProvider({Key key, Widget child, this.auth})
      : super(key: key, child: child);

  static AuthProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AuthProvider) as AuthProvider;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

}
