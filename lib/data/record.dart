import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String name, address, description, imageUrl;
  final int phoneNumber;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Name'] != null),
        assert(map['Address'] != null),
        assert(map['Description'] != null),
        assert(map['Phone Number'] != null),
        assert(map['Image Url'] != null),
        name = map['Name'],
        address = map['Address'],
        description = map['Description'],
        phoneNumber = map['Phone Number'],
        imageUrl = map['Image Url'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name, $address, $description, $phoneNumber>";
}
