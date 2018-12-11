import 'package:chat_with_friends/ui/chat/chat.dart';
import 'package:flutter/material.dart';

class ChatPageView extends ChatPageState {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPress,
        child: Scaffold(
          appBar: AppBar(title: Text('CHAT'),centerTitle: true,),
          body: Stack(
            children: <Widget>[
              user != null
                  ? Column(
                      children: <Widget>[buildListMessage(), buildInput(),
                                    (isShowSticker ? buildSticker() : Container()),

                      ],
                    )
                  : buildLoading(),
                  buildLoading(),
            ],
          ),
        ));
  }
}
