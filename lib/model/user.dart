import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String imagePath;
  final String password;
  User({this.name, this.email, this.id, this.imagePath, this.password});

  //fields
  static final String _id = 'id';
  static final String _name = 'name';
  static final String _email = 'email';
  static final String _password = 'password';
  static final String _imagePath = 'image path';

  Map<String, dynamic> toJson() => {
        _id: id,
        _name: name,
        _email: email,
        _password: password,
        _imagePath: imagePath
      };

  factory User.fromJson(DocumentSnapshot doc) => User(
        id: doc[_id],
        name: doc[_name],
        email: doc[_email],
        password: doc[_password],
        imagePath: doc[_imagePath],
      );

  @override
  String toString() =>
      'User Info >> id $id, image path $imagePath, name $name, email $email, <<';
}
