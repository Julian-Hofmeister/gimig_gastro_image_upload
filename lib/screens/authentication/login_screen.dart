import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gimig_gastro_image_upload/services/authentication_servie.dart';

import 'package:provider/provider.dart';

import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.03,
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.14,
                ),
                Container(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.02,
                  ),
                  // height: MediaQuery.of(context).size.width * 0.3,
                  // width: MediaQuery.of(context).size.width * 0.3,
                  height: 130,
                  width: 130,
                  child: Image.asset(
                    "images/Gimig Logo.png",
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "E-mail:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF303030),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.01,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.1,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        cursorHeight: MediaQuery.of(context).size.width * 0.045,
                        cursorWidth: 1.2,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 13,
                            horizontal: 15,
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  MediaQuery.of(context).size.width * 0.06),
                            ),
                            borderSide:
                                new BorderSide(color: Colors.deepOrangeAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: Color(0xFFFF6633)),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  MediaQuery.of(context).size.width * 0.06),
                            ),
                          ),
                        ),
                        cursorColor: Color(0xFF303030),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Passwort:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF303030),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.01,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.1,
                      child: Theme(
                        child: TextField(
                          obscureText: obscureText,
                          onChanged: (value) {
                            password = value;
                          },
                          cursorHeight:
                              MediaQuery.of(context).size.width * 0.045,
                          cursorWidth: 1.2,
                          decoration: new InputDecoration(
                            suffixIcon: IconButton(
                                splashColor: Colors.white,
                                splashRadius: 1,
                                icon: Icon(
                                  obscureText == false
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscureText == true
                                        ? obscureText = false
                                        : obscureText = true;
                                  });
                                }),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 13,
                              horizontal: 15,
                            ),
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    MediaQuery.of(context).size.width * 0.06),
                              ),
                              borderSide: new BorderSide(
                                  color: Colors.deepOrangeAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Color(0xFFFF6633)),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    MediaQuery.of(context).size.width * 0.06),
                              ),
                            ),
                          ),
                          cursorColor: Color(0xFF303030),
                        ),
                        data: Theme.of(context).copyWith(
                          primaryColor: Colors.tealAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.252),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.06),
                      ),
                      color: Color(0xFFFF6633),
                      splashColor: Colors.white,
                      highlightColor: Colors.tealAccent,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: () {
                        if (email != null && password != null) {
                          context.read<AuthenticationService>().signIn(
                                email: email.trim(),
                                password: password.trim(),
                                context: context,
                              );
                        }
                      }),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(
                          "Registrieren",
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
