/* IMPORT PACKAGE */
import 'package:flutter/material.dart';
import 'package:waroeng_app/services/fire_auth_service.dart';

class LoginPage extends StatefulWidget {
  /* Constructor */
  LoginPage({this.auth, this.loginCallback});
  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false, _isLoginForm = true;
  String _mEmail, _mPassword;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void resetForm() {
    _formKey.currentState.reset();
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_mEmail, _mPassword);
          print('Pengguna Masuk: $userId'); // LOG
        } else {
          userId = await widget.auth.signUp(_mEmail, _mPassword);
          print('Pengguna Terdaftar: $userId'); // LOG
        }

        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        } else {
          _isLoading = false;
        }
      } catch (e) {
        print('Terjadi Kesalahan: $e'); // LOG
        setState(() {
          _isLoading = false;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/background.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: _authForm(),
        ),
      ),
    );
  }

  Widget _authForm() {
    return Container(
      child: Form(
        key: _formKey,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 80.0,
              vertical: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _appLogo(),
                _emailTextField(),
                _passwordTextField(),
                SizedBox(
                  height: 20.0,
                ),
                _primaryButton(),
                SizedBox(
                  height: 10.0,
                ),
                _authStatusLabel(),
                _secondaryButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appLogo() {
    return Image(
      width: 150.0,
      image: AssetImage('images/red_logo.png'),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      cursorColor: Colors.red[800],
      autofocus: false,
      obscureText: false,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email',
      ),
      validator: (value) => value.isEmpty ? "Email tidak boleh kosong" : null,
      onSaved: (value) => _mEmail = value.trim(),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      cursorColor: Colors.red[800],
      autofocus: false,
      obscureText: true,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Password',
      ),
      validator: (value) =>
          value.isEmpty ? "Password tidak boleh kosong" : null,
      onSaved: (value) => _mPassword = value.trim(),
    );
  }

  Widget _primaryButton() {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 14.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: _isLoading
          ? SizedBox(
              height: 16.0,
              width: 16.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              _isLoginForm ? 'Masuk' : 'Daftar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
      color: Colors.red[800],
      onPressed: () {
        validateAndSubmit();
      },
    );
  }

  Widget _authStatusLabel() {
    return Center(
      child: Text(
        _isLoginForm ? 'Belum punya akun?' : 'Sudah punya akun?',
        style: TextStyle(
          color: Colors.red[400],
        ),
      ),
    );
  }

  Widget _secondaryButton() {
    return FlatButton(
      child: Text(
        _isLoginForm ? 'Daftar' : 'Masuk',
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      onPressed: () {
        toggleFormMode();
      },
    );
  }
}
