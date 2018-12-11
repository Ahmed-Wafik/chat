import 'package:chat_with_friends/model/band.dart';
import 'package:chat_with_friends/services/auth_provider.dart';
import 'package:chat_with_friends/services/firebase_services.dart';
import 'package:chat_with_friends/services/root.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: RoutePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Firestore db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: StreamBuilder(
        stream: db.collection('bandnames').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: const CircularProgressIndicator());
          } else {
            List<Band> bandList = Band.bandList(snapshot.data.documents);
            return ListView.builder(
              shrinkWrap: true,
              itemCount: bandList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(bandList[index].name),
                  leading: CircleAvatar(
                    child: Text(bandList[index].votes.toString()),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
