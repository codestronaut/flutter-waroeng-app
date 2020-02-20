/* IMPORT PACKAGE */
import 'package:flutter/material.dart';
import 'package:waroeng_app/controller/page_controller.dart';
import 'package:waroeng_app/services/fire_auth_service.dart';

// MAIN FUNCTION
void main() => runApp(WaroengApp());

// WaroengApp StatelessW
class WaroengApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.red[800],
        accentColor: Colors.grey[350],
      ),
      themeMode: ThemeMode.light,
      home: PageControl(
        auth: Auth(),
      ),
    );
  }
}
