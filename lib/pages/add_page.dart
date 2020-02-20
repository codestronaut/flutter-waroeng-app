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
          iconTheme: IconThemeData(color: Colors.red[800]),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Tambah Warung',
            style: TextStyle(
              color: Colors.red[800],
            ),
          ),
        ),
        body: Center(
          child: Text('Halaman Kosong'),
        ),
      ),
    );
  }
}
