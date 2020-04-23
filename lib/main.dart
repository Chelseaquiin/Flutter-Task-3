import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Display Data From API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var _users = [];
  ProgressDialog pr;
  bool showProgress = false;
  void _fetchUsers() async{
    pr.show();
    var response = await http.get("https://jsonplaceholder.typicode.com/users");
    if(response.statusCode == 200){
      var users = jsonDecode(response.body);
      setState(() {
        _users = users;
      });

    }else{

    }
    pr.hide();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Please Waiting...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
              children: <Widget>[
               ... _users.map((user){
                 return  UserCard(user:user);
               }),
              ],
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchUsers,
        tooltip: 'Increment',
        child: Icon(Icons.autorenew),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class UserCard extends StatelessWidget {
  final Map user;

  const UserCard({Key key, this.user}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return UserDetailsPage(user);
        }));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Row(
                  children: [Text("Name:"), Text(user['name'])]
              ),
              Row(
                  children: [Text("Username:"), Text(user['email'])]
              ),
              Row(
                children: <Widget>[],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetailsPage extends StatelessWidget {
  final Map user;

  const UserDetailsPage(this.user, {Key key, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[

        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Name: ${user['name']}"),
                    ],
                  ),
                  Detail(title: "Address",value: user['address']['street'],),
                  Row(
                    children: <Widget>[
                      Text("Email:"),
                      Text(user['email'])
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Phone:"),
                      Text(user['phone'])
                    ],
                  ),
                ],
                    ),
            ),
          ),
          ),
        ),
      );
  }
}


class Detail extends StatelessWidget {
  final String title;
  final String value;

  const Detail({Key key, this.title, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(

        children: <Widget>[
          Text(title+": ",style: TextStyle(
            fontSize: 20,
          ),),
          Text(value,style: TextStyle(
          fontSize: 20,
          color: Colors.black54
      ))
        ],
      ),
    );
  }
}
