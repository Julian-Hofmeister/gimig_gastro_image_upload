import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gimig_gastro_image_upload/main.dart';
import 'package:gimig_gastro_image_upload/screens/display_screen.dart';

final _auth = FirebaseAuth.instance;

AppBar headerNav({String title, context}) {
  return AppBar(
    backgroundColor: Color(0xFF363636).withOpacity(0),
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, DisplayScreen.id);
            }),
        Text(
          title,
          style: TextStyle(
            letterSpacing: 1.5,
          ),
        ),
        GestureDetector(
          onTap: () {
            _auth.signOut();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AuthenticationWrapper()));
          },
          child: Container(
            margin: EdgeInsets.all(12),
            height: 25,
            width: 25,
            child: Image.asset(
              "images/logos/gimig_logo_white_clean.png",
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    ),
  );
}
