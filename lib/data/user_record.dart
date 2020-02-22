import 'package:cloud_firestore/cloud_firestore.dart';

class UserRecord {
  final String userId, userName, userEmail;
  final int userPhone;
  final DocumentReference reference;

  UserRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['UserId'] != null),
        assert(map['Username'] != null),
        assert(map['UserEmail'] != null),
        assert(map['UserPhone'] != null),
        userId = map['UserId'],
        userName = map['Username'],
        userEmail = map['UserEmail'],
        userPhone = map['UserPhone'];

  UserRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "UserRecord<$userId, $userName, $userEmail, $userPhone>";
}
