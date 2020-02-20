/* IMPORT PACKAGE */
import 'package:flutter/material.dart';
import 'package:waroeng_app/services/fire_auth_service.dart';
import 'package:waroeng_app/pages/add_page.dart';

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
                leading: Icon(Icons.store),
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
          centerTitle: true,
          title: Image(
            image: AssetImage('images/logo.png'),
            height: 70.0,
          ),
        ),
        body: _menuGridView(),
      ),
    );
  }

  Widget _menuGridView() {
    return Container(
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(3, (index) {
          return Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 8.0,
              top: 8.0,
            ),
            child: Card(
              child: Center(
                child: Text(
                  'This is card!',
                ),
              ),
            ),
          );
        }),
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
        // logOut();
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
