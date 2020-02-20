/* IMPORT PACKAGE */
import 'package:flutter/material.dart';
import 'package:waroeng_app/services/fire_auth_service.dart';
import 'package:waroeng_app/pages/login_page.dart';
import 'package:waroeng_app/pages/dashboard_page.dart';

// AuthStatu: Digunakan untuk menentukan status login
enum AuthStatus {
  NOT_DETERMINED, // Login atau logout belum
  NOT_LOGGED_IN, // Belum login
  LOGGED_IN, // Sudah login
}

/*
  StatefulWidget
  => Class PageControl digunakan untuk mengontrol rute
  => Rute yang dimaksud disini adalah kemana page akan dialihkan setelah login 
*/
class PageControl extends StatefulWidget {
  PageControl({this.auth});
  final BaseAuth auth;

  @override
  _PageControlState createState() => _PageControlState();
}

class _PageControlState extends State<PageControl> {
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  /*
    INIT STATE
    => Dipanggil saat program pertama kali dibuka
  */
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        _authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  /*
    BUILD FUNCTION
  */
  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildLoadingIndicator();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          auth: widget.auth,
          loginCallback: _loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new DashboardPage(
            auth: widget.auth,
            logoutCallback: _logoutCallback,
            userId: _userId,
          );
        } else {
          return _buildLoadingIndicator();
        }
        break;
      default:
        return _buildLoadingIndicator();
    }
  }

  // Indikator Loading
  Widget _buildLoadingIndicator() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red[800]),
        ),
      ),
    );
  }

  // LoginCallback => Mendeteksi login
  void _loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid;
      });
    });
    setState(() {
      _authStatus = AuthStatus.LOGGED_IN;
    });
  }

  // LogoutCallback => Mendeteksi logout
  void _logoutCallback() {
    setState(() {
      _userId = "";
      _authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }
}
