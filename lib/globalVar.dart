import 'package:flutter/material.dart';

Map<String, double> oweMap= Map<String, double>();

class UserTransactions{
  double amount;
  String receiver;
  String ower;
  String id;

}

BoxDecoration kBoxDecorationStyle = BoxDecoration(
  color: Color(0x40FFFFFF),
  borderRadius: BorderRadius.circular(100.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

TextStyle whiteSmallTextStyle=  TextStyle(
  color: Colors.white,
);

TextStyle whiteBigTextStyle=  TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 25
);
TextStyle greyTextStyle=  TextStyle(
  color: Colors.grey,
);