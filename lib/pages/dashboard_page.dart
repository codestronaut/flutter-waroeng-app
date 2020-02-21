/* IMPORT PACKAGE */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waroeng_app/services/fire_auth_service.dart';
import 'package:waroeng_app/pages/add_page.dart';
import 'package:waroeng_app/data/record.dart';

/*
  DASHBOARD PAGE
*/
class DashboardPage extends StatefulWidget {
  /* Constructor */
  DashboardPage({this.auth, this.logoutCallback, this.userId});

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red[800],
            child: Icon(Icons.message),
            onPressed: () {
              // NOT IMPLEMENT YET
            }),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.grey[800]),
                padding: EdgeInsets.all(30.0),
                child: Container(
                  child: CircleAvatar(
                    backgroundColor: Colors.red[400],
                    child: Text(
                      'A',
                      style: TextStyle(
                        fontSize: 50.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Buat Warung'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.store),
                title: Text('Warung Saya'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Riwayat Pesanan'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  showAlertDialog(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.red[800]),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Image(
            image: AssetImage('images/red_logo.png'),
            height: 70.0,
          ),
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('food_store').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          );

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
      childAspectRatio: 0.75,
      crossAxisCount: 2,
      padding: EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red[800],
          ),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                record.name,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                record.description,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.place),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(record.address),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.phone),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(record.phoneNumber.toString()),
                ],
              ),
              SizedBox(
                height: 24.0,
              ),
              OutlineButton(
                child: Text('Detail'),
                splashColor: Colors.red[400],
                highlightedBorderColor: Colors.red[800],
                onPressed: () {
                  // NOT IMPLEMENT YET
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void logOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print('Terjadi kesalahan: $e'); // LOG
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'Batal',
        style: TextStyle(color: Colors.red[800]),
      ),
    );

    Widget continueButton = FlatButton(
      onPressed: () {
        logOut();
        Navigator.pop(context);
      },
      child: Text(
        'Keluar',
        style: TextStyle(color: Colors.red[800]),
      ),
    );

    AlertDialog logoutAlert = AlertDialog(
      title: Text('Peringatan'),
      content: Text('Keluar sekarang?'),
      actions: <Widget>[cancelButton, continueButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return logoutAlert;
      },
    );
  }
}
