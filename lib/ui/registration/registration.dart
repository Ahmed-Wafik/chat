import 'dart:io';

import 'package:chat_with_friends/model/user.dart';
import 'package:chat_with_friends/services/auth_provider.dart';
import 'package:chat_with_friends/services/firebase_services.dart';
import 'package:chat_with_friends/ui/registration/registration_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LogInPage extends StatefulWidget {
  final VoidCallback onSignIn;

  LogInPage({this.onSignIn});
  LogInView createState() => LogInView();
}

enum FormType { login, signUp }

abstract class LogInPageState extends State<LogInPage> {
  FormType formType = FormType.signUp;
  String userName;
  String email;
  String password;

  final usernameNode = FocusNode();
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  final conformPassNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  File image;
  bool loading = false;
  String id;

  onFocusNodeChange(BuildContext context, FocusNode currentFocusNode,
      FocusNode nextFocusNode) {
    currentFocusNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  moveToSignUp() {
    setState(() {
      _clearData();
      formType = FormType.signUp;
    });
  }

  moveTologIn() {
    setState(() {
      _clearData();
      formType = FormType.login;
    });
  }

  _clearData() {
    passwordController.clear();
    image = null;
  }

  bool _validateAndSave() {
    var v = formKey.currentState;
    if (v.validate()) {
      v.save();
      return true;
    }
    return false;
  }

  chooseImagePicker() => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Camera'),
                leading: Icon(Icons.camera_alt),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                title: Text('Gallary'),
                leading: Icon(Icons.photo_album),
                onTap: () => _pickImage(ImageSource.gallery),
              )
            ],
          ));

  Future _pickImage(ImageSource source) async {
    Navigator.of(context).pop(context);
    ImagePicker.pickImage(source: source).then((img) {
      img
          .length()
          .then((value) => print('original image $value'))
          .then((_) => _cropImage(img).then((croppedImg) {
                croppedImg.length().then((v) => print('cropped iamge size $v'));
                setState(() {
                  image = croppedImg;
                });
              }));
    });
  }

  submit() {
    if (_validateAndSave()) {
      var auth = AuthProvider.of(context).auth;
      setState(() {
        loading = true;
      });
      if (formType == FormType.signUp) {
        _signUp(auth);
      } else {
        _logIn(auth);
      }
    }
  }

  _logIn(BaseAuth auth) async {
    try {
      await auth.logIn(email: email, password: password);
      widget.onSignIn();
    } catch (e) {
      _showErrorMessage('Login falied');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  _showErrorMessage(String errorMsg) =>
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[Text(errorMsg), Icon(Icons.error)],
          ),
        ),
      ));
  _signUp(BaseAuth auth) => auth
      .signUp(email: email, password: password)
      .then((userID) {
        setState(() {
          id = userID;
        });
        print('user id : $id');
      })
      .then((_) => _uploadImg()
          .then((imgUrl) => _saveToDB(id, imgUrl))
          .catchError(print))
      .whenComplete(() {
        setState(() {
          loading = false;
        });
        widget.onSignIn();
      })
      .catchError(print);
  
  _saveToDB(String userID, String imgPath) {
    Firestore db = Firestore.instance;
    db.settings(persistenceEnabled: true);
    return db.collection('users').document(userID).setData(User(
            email: email,
            name: userName,
            id: userID,
            imagePath: imgPath,
            password: password)
        .toJson());
  }

  Future<dynamic> _uploadImg() async {
    StorageReference ref =
        FirebaseStorage.instance.ref().child("profile pictures/$id");
    StorageUploadTask task = ref.putFile(image);
    StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  Future<File> _cropImage(File imageFile) async {
    var file = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    return file;
  }

  @override
  void dispose() {
    if (formKey.currentState != null) {
      formKey.currentState.dispose();
    }
    passwordController.dispose();
    super.dispose();
  }
}
