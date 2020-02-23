import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final databaseReference = Firestore.instance;
  String foodStoreId, foodStoreName = '';
  @override
  Widget build(BuildContext context) {
    foodStoreId = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.red[800]),
          title: Text(
            'Detail',
            style: TextStyle(
              color: Colors.red[800],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder(
          stream: databaseReference
              .collection('food_store')
              .document(foodStoreId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var foodStoreDocuments = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 320.0,
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(foodStoreDocuments['Image Url']),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            foodStoreDocuments['Name'],
                            style: TextStyle(fontSize: 30.0),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                foodStoreDocuments['Address'],
                                style: TextStyle(fontSize: 16.0),
                              ),
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
                              Text(
                                foodStoreDocuments['Phone Number'].toString(),
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            foodStoreDocuments['Description'],
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Divider(
                            thickness: 1.0,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
