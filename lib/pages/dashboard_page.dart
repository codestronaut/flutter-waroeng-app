/* IMPORT PACKAGE */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waroeng_app/services/fire_auth_service.dart';
import 'package:waroeng_app/pages/add_page.dart';
import 'package:waroeng_app/data/record.dart';
import 'package:waroeng_app/pages/detail_page.dart';

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
  String foodStoreId, userEmail;

  @override
  void initState() {
    getUserEmail();
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'images/header.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: EdgeInsets.all(30.0),
                child: Container(
                  child: CircleAvatar(
                    backgroundColor: Colors.red[400],
                    child: Text(
                      userEmail,
                      style: TextStyle(
                        fontSize: 45.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Tambah Kedai'),
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
                leading: Icon(Icons.info),
                title: Text('About App'),
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
      childAspectRatio: 0.7,
      crossAxisCount: 2,
      padding: EdgeInsets.only(top: 20.0),
      children:
          snapshot.map((data) => _buildCardListItem(context, data)).toList(),
    );
  }

  Widget _buildCardListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Card(
        child: InkWell(
          splashColor: Colors.red[800].withAlpha(80),
          onTap: () {
            // NOT IMPLEMENT YET
            foodStoreId = record.reference.documentID.toString();
            print(foodStoreId);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(),
                settings: RouteSettings(
                  arguments: foodStoreId,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    height: 150.0,
                    placeholder: 'images/placeholder.png',
                    image: record.imageUrl,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  record.name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      size: 16.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(record.address),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getUserEmail() async {
    try {
      widget.auth.getCurrentUser().then((user) {
        setState(() {
          userEmail = user.email[0].toUpperCase();
        });
      });
    } catch (e) {
      print('Terjadi kesalahan: $e'); // LOG
    }
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
