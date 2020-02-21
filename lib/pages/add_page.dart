/* IMPORT PACKAGE */
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
  AddPage
  => Page untuk menambahkan warung dan menyimpan ke database
*/
class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final databaseReference = Firestore.instance;
  String _mName, _mAddress, _mDescription, _mPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.red[800]),
          centerTitle: true,
          title: Text(
            'Tambah Warung',
            style: TextStyle(color: Colors.red[800]),
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Nama',
              ),
              validator: (value) => value.isEmpty ? "Tidak boleh kosong" : null,
              onSaved: (value) => _mName = value.trim(),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Alamat',
              ),
              validator: (value) => value.isEmpty ? "Tidak boleh kosong" : null,
              onSaved: (value) => _mAddress = value.trim(),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Deskripsi',
              ),
              validator: (value) => value.isEmpty ? "Tidak boleh kosong" : null,
              onSaved: (value) => _mDescription = value.trim(),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Nomor Handphone',
              ),
              validator: (value) => value.isEmpty ? "Tidak boleh kosong" : null,
              onSaved: (value) => _mPhoneNumber = value.trim(),
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
                setState(() {
                  _addRecord();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _addRecord() async {
    if (_validateAndSave()) {
      await databaseReference.collection('food_store').document().setData({
        'Name': _mName,
        'Address': _mAddress,
        'Description': _mDescription,
        'Phone Number': int.parse(_mPhoneNumber)
      });
    }
  }
}
