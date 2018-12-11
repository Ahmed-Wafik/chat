import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String content;
  final String idFrom;
  final String idTo;
  final String time;
  final int type;
  Chat({this.content, this.idFrom, this.idTo, this.time, this.type});
  static String _content = 'content';
  static String _idFrom = 'idFrom';
  static String _idTo = 'idTo';
  static String _time = 'time';
  static String _type = 'type';

  factory Chat.fromJson(DocumentSnapshot doc) => Chat(
      idFrom: doc[_idFrom],
      idTo: doc[_idTo],
      content: doc[_content],
      time: doc[_time],
      type: doc[_type]);

  Map<String, dynamic> toJson() => {
        _idTo: idTo,
        _idFrom: idFrom,
        _content: content,
        _time: time,
        _type: type
      };
}
