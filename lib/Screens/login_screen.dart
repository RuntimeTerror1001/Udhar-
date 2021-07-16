import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udhar_app/API/auth_api.dart';
import 'package:udhar_app/Models/user.dart';
import 'package:udhar_app/Notifiers/auth_notifier.dart';
import 'package:udhar_app/Screens/reset_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_fonts/google_fonts.dart';

enum AuthMode { SignUp, Login }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  User _user = User();
  bool? _passwordVisible;

  Widget _buildDisplayNameField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Display Name',
        hintStyle: TextStyle(color: Colors.black),
        fillColor: Colors.white54,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
        ),
      ),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20, color: Colors.black),
      cursorColor: Colors.white,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Display Name is required';
        }

        if (value.length < 5 || value.length > 12) {
          return 'Display Name must be betweem 5 and 12 characters';
        }

        return null;
      },
      onSaved: (value) {
        _user.displayName = value.toString();
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email Address',
        hintStyle: TextStyle(color: Colors.black),
        fillColor: Colors.white54,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 20, color: Colors.black),
      cursorColor: Colors.white,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email is required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }

        return null;
      },
      onSaved: (value) {
        _user.email = value.toString();
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.black),
        fillColor: Colors.white54,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible! ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !(_passwordVisible!);
            });
          },
        ),
      ),
      style: TextStyle(fontSize: 20, color: Colors.black),
      cursorColor: Colors.white,
      obscureText: !_passwordVisible!,
      controller: _passwordController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password is required';
        }

        if (value.length < 5 || value.length > 20) {
          return 'Password must be betweem 5 and 20 characters';
        }

        return null;
      },
      onSaved: (value) {
        _user.password = value.toString();
      },
    );
  }

  Widget _forgetPass() {
    return TextButton(
      child: Text('Forgot Password',
          style: GoogleFonts.raleway(fontSize: 16, color: Colors.white54)),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetScreen()));
      },
    );
  }

  void submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    if (_authMode == AuthMode.Login) {
      login(_user, authNotifier);
    } else {
      signup(_user, authNotifier);
    }
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Building Login Screen');

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: (_authMode == AuthMode.Login ? 'LOGIN ' : 'SIGN UP').text.make(),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32, 15, 32, 0),
            child: VStack(
              [
                Center(
                  child: Text(
                    "Please Sign In",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 36, color: Colors.white54),
                  ),
                ),
                SizedBox(height: 32),
                _authMode == AuthMode.SignUp
                    ? _buildDisplayNameField()
                    : Container(),
                20.heightBox,
                _buildEmailField(),
                20.heightBox,
                _buildPasswordField(),
                15.heightBox,
                _authMode == AuthMode.Login ? _forgetPass() : Container(),
                SizedBox(height: 32),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _authMode = _authMode == AuthMode.Login
                          ? AuthMode.SignUp
                          : AuthMode.Login;
                    });
                  },
                  child: Center(
                    child: Text(
                      'Switch to ${_authMode == AuthMode.Login ? 'Sign Up' : 'Login'}',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ButtonTheme(
                    minWidth: 200,
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).accentColor),
                      onPressed: () => submitForm(),
                      child: Text(
                        _authMode == AuthMode.Login ? 'Login' : 'Sign Up',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ).scrollVertical(),
          ),
        ),
      ),
    );
  }
}
