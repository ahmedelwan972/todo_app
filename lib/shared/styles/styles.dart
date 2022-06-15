import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


ThemeData lightTheme =  ThemeData(
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedItemColor: Colors.grey,
      type:BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
    elevation: 0,
  ),
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme:const  AppBarTheme(
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
      statusBarIconBrightness: Brightness.light,
    ),
    elevation: 0.0,
   // color: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 30.0,
    ),
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 0.0,
    backgroundColor: Colors.grey[900],
    unselectedItemColor: Colors.grey[500],
    selectedItemColor: Colors.purple.shade100
  ),
  primarySwatch: Colors.purple,
  scaffoldBackgroundColor: Colors.grey[900],
  appBarTheme: const AppBarTheme(
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.purple,
        statusBarIconBrightness: Brightness.light),
    elevation: 0.0,
    color: Colors.purple,
    iconTheme:  IconThemeData(color: Colors.white),
    titleTextStyle:  TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 30.0,
    ),
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
);
