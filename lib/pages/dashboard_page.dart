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
            image: AssetImage('images/logo.png'),
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
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)],
          image: DecorationImage(
            image: NetworkImage(
              record.imageUrl,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            bottom: 16.0,
            right: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                record.name,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
