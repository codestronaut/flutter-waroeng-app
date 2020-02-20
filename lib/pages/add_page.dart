/* IMPORT PACKAGE */
import 'package:flutter/material.dart';

/*
  AddPage
  => Page untuk menambahkan warung dan menyimpan ke database
*/
class AddPage extends StatefulWidget {
  AddPage({Key key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Tambah Warung',
          ),
        ),
        body: Center(
          child: _formAddFoodStore(),
        ),
      ),
    );
  }

  Widget _formAddFoodStore() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'images/add_background.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 60.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Nama',
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Alamat',
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Deskripsi',
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Nomor Handphone',
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Link Foto',
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              'Daftar',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            color: Colors.red[400],
            onPressed: () {
              // NOT IMPLEMENT YET!
            },
          ),
        ],
      ),
    );
  }
}
