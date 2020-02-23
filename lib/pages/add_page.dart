/* IMPORT PACKAGE */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';

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
  String _mName, _mAddress, _mDescription, _mPhoneNumber, _mImageUrl;
  String _fileType = '';
  File file;
  String _fileName = '';

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
              height: 10.0,
            ),
            OutlineButton(
              onPressed: () {
                setState(() {
                  _fileType = 'image';
                });
                _filePicker(context);
              },
              highlightedBorderColor: Colors.red[400],
              child: Text('Upload Gambar'),
            ),
            SizedBox(
              height: 20.0,
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
                Navigator.pop(context);
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
        'Phone Number': int.parse(_mPhoneNumber),
        'Image Url': _mImageUrl,
      });
    }
  }

  Future _filePicker(BuildContext context) async {
    try {
      if (_fileType == 'image') {
        file = await FilePicker.getFile(type: FileType.IMAGE);
        setState(() {
          _fileName = p.basename(file.path);
        });
        print(_fileName);
        _uploadFile(file, _fileName);
      }
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Maaf'),
            content: Text('Tipe file salah! : $e'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _uploadFile(File file, String fileName) async {
    StorageReference storageRef;
    if (_fileType == 'image') {
      storageRef = FirebaseStorage.instance.ref().child('images/$_fileName');
    }
    final StorageUploadTask storageUpload = storageRef.putFile(file);
    final StorageTaskSnapshot downloadURL = (await storageUpload.onComplete);
    final String url = (await downloadURL.ref.getDownloadURL());
    setState(() {
      _mImageUrl = url;
    });
    print('URL is: $url'); // LOG
  }
}
