import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:udhar_app/API/auth_api.dart';
import 'package:velocity_x/velocity_x.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email;

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email Address',
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
        email = value.toString();
      },
    );
  }

  void submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    print('Building Reset Screen');

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: 'RESET'.text.make(),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32, 15, 32, 0),
            child: VStack(
              [
                Text(
                  "Reset Password",
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.poppins(fontSize: 36, color: Colors.white54),
                ),
                SizedBox(height: 32),
                _buildEmailField(),
                15.heightBox,
                ButtonTheme(
                  minWidth: 200,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).accentColor),
                    child: Text(
                      'Send Email',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    onPressed: () {
                      submitForm();
                      resetPass(email.toString());
                      Navigator.pop(context);
                    },
                  ),
                ),
                ButtonTheme(
                  minWidth: 200,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ).scrollVertical(),
          ),
        ),
      ),
    );
  }
}
