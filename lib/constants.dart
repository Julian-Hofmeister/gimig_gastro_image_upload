import 'package:flutter/material.dart';

final kDarkTextFieldDecoration = InputDecoration(
  disabledBorder: InputBorder.none,
  fillColor: Color(0xFF4B4B4B),
  filled: true,
  contentPadding: EdgeInsets.symmetric(
    vertical: 13,
    horizontal: 15,
  ),
  border: new OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(40),
    ),
    borderSide: new BorderSide(
      color: Color(0xFF4B4B4B),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: new BorderSide(
      color: Color(0xFFFFA374),
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: new BorderSide(
      color: Color(0xFF4B4B4B),
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
  ),
);

final kDetailTextStyle = TextStyle(
  fontSize: 16,
  letterSpacing: 0.5,
  fontWeight: FontWeight.w400,
  color: Color(0xFFCFCFCF),
);

final kFoodCardTitleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

final kFoodCardDescTextStyle = TextStyle(
  color: Color(0xFFD9D9D9),
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

final kFoodCardPriceTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);
