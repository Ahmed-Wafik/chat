import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_with_friends/model/chat.dart';
import 'package:chat_with_friends/model/user.dart';
import 'package:chat_with_friends/services/auth_provider.dart';
import 'package:chat_with_friends/ui/chat/chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final User peerUser;
  const ChatPage({Key key, this.peerUser}) : super(key: key);
  ChatPageView createState() => ChatPageView();
}

abstract class ChatPageState extends State<ChatPage> {
  String groupID = '';
  List<DocumentSnapshot> messageList;
  bool isShowSticker = false;
  bool isLoading = false;
  File imageFile;
  String imageUrl;
  User user;
  Chat chat;

  Color _grey = Colors.grey[300];
  Color _purple = Colors.purple;
  Color _rightTxtColor = Colors.grey[800];
  Color _leftTxtColor = Colors.white;

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  getGroubcahtId() {
    if (user.id.hashCode <= widget.peerUser.id.hashCode) {
      groupID = '${user.id} - ${widget.peerUser.id}';
    } else {
      groupID = '${widget.peerUser.id} - ${user.id}';
    }
    print('group id : $groupID');
    setState(() {});
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference =
        FirebaseStorage.instance.ref().child('message/$groupID/$fileName');
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(content: imageUrl, type: 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
      // Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  buildSticker() {
    return Container(
      child: Table(
        children: [
          TableRow(
            children: List.generate(3, (index)
              =>_stickerItem(index+1)
            )
          ),
          TableRow(
            children: List.generate(3, (index)
              =>_stickerItem(index+4)
            )
          ),
          TableRow(
            children: List.generate(3, (index)
              =>_stickerItem(index+7)
            )
          ),
        ],
      )
    );
  }

  _stickerItem(int x) => FlatButton(
        onPressed: () => onSendMessage(content: 'mimi$x', type: 2),
        child: new Image.asset(
          'images/mimi$x.gif',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );

  Widget buildListView(int index, Chat chat) {
    if (chat.idFrom == user.id) {
      //right message
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[_buildRightMessage(chat)],
      );
    } else {
      return _buildLeftMessage(chat);
    }
  }

  _buildRightMessage(
    Chat chat,
  ) {
    switch (chat.type) {
      //messgae content = Text
      case 0:
        return _contentText(chat);
        break;
      //content message = Image
      case 1:
        return _contentImage(chat);
        break;
      //message content = gif
      case 2:
        return _contentGif(chat);
    }
  }

  Widget _buildLeftMessage(Chat chat) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Material(
              child: CachedNetworkImage(
                placeholder: Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                  width: 35,
                  height: 35,
                  padding: EdgeInsets.all(10),
                ),
                imageUrl: widget.peerUser.imagePath,
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
              clipBehavior: Clip.hardEdge,
            ),
            chat.type == 0
                ? _contentText(chat, right: false)
                : chat.type == 1
                    ? _contentImage(chat, right: false)
                    : _contentGif(chat)
          ]),
          Container(
            child: Text(
              DateFormat('dd MMM kk:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(int.parse(chat.time))),
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic),
            ),
            margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: EdgeInsets.only(bottom: 10.0),
    );
  }

  Container _contentImage(Chat chat, {bool right = true}) {
    return Container(
      child: Material(
        child: CachedNetworkImage(
          placeholder: Container(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(_purple),
            ),
            width: 200,
            height: 200,
            padding: EdgeInsets.all(70),
            decoration: BoxDecoration(
              color: _grey,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
          errorWidget: Material(
            child: Image.asset(
              'images/img_not_available.jpeg',
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            clipBehavior: Clip.hardEdge,
          ),
          imageUrl: chat.content,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        clipBehavior: Clip.hardEdge,
      ),
      margin: EdgeInsets.only(
          right: right ? 10 : 0, left: !right ? 10 : 0, bottom: 10),
    );
  }

  Container _contentGif(Chat chat, {bool right = true}) {
    return Container(
      child: new Image.asset(
        'images/${chat.content}.gif',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
      margin: EdgeInsets.only(
          bottom: 10, right: right ? 10 : 0, left: !right ? 10 : 0),
    );
  }

  Container _contentText(Chat chat, {bool right = true}) {
    return Container(
      child: Text(
        chat.content,
        style: TextStyle(
            color: right ? _rightTxtColor : _leftTxtColor,
            fontSize: 16,
            letterSpacing: .8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: 200,
      decoration: BoxDecoration(
          color: right ? _grey : _purple,
          borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(
          bottom: 10, right: right ? 10 : 0, left: !right ? 10.0 : 0),
    );
  }

  Widget buildListMessage() {
    return Flexible(
        child: groupID == ''
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)))
            : StreamBuilder(
                stream: Firestore.instance
                    .collection('messages')
                    .document(groupID)
                    .collection(groupID)
                    .orderBy('time', descending: true)
                    .limit(20)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.purple)));
                  } else {
                    messageList = snapshot.data.documents;
                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: messageList.length,
                      reverse: true,
                      controller: listScrollController,
                      itemBuilder: (BuildContext context, int index) {
                        chat = Chat.fromJson(messageList[index]);
                        return buildListView(index, chat);
                      },
                    );
                  }
                }));
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1),
              child: new IconButton(
                  icon: new Icon(Icons.image),
                  onPressed: getImage,
                  color: Colors.orange),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                onPressed: getSticker,
                color: Colors.purple,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.purple, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () =>
                    onSendMessage(content: textEditingController.text, type: 0),
                color: Colors.purple,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: Colors.grey[400], width: 0.5)),
          color: Colors.white),
    );
  }

  onSendMessage({String content, int type}) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();
      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupID)
          .collection(groupID)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
            documentReference,
            Chat(
                    idFrom: user.id,
                    idTo: widget.peerUser.id,
                    content: content,
                    time: DateTime.now().millisecondsSinceEpoch.toString(),
                    type: type)
                .toJson());
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      //Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildLoading() {
    return Positioned(
      bottom: 0,
      top: 0,
      right: 0,
      left: 0,
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var auth = AuthProvider.of(context).auth;
    auth.userInfo().then((onValue) {
      setState(() {
        user = User.fromJson(onValue);
        getGroubcahtId();
      });
    }).catchError(print);
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    print(user.toString());
  }
}
