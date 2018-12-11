import 'package:cloud_firestore/cloud_firestore.dart';

class Band {
  String name;
  int votes;
  Band(this.name, this.votes);

  static List<Band> items = [
    Band('Deep Puprle', 5),
    Band('Muse', 1),
    Band('Dire Straits', 2),
    Band('Led Zeplin', 8),
  ];

  factory Band.fromJson(DocumentSnapshot json) =>
      Band(json['name'], json['votes'] as int);

  static List<Band> bandList(List<DocumentSnapshot> list) {
    return list.map((f) => Band.fromJson(f)).toList();
  }

  @override
  String toString() => 'Name $name , Votes $votes';
}
