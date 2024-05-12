import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:getiks/pages/home_page.dart';
import 'package:getiks/utils.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  await registerServices();
  await registerController();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Demo",
      theme:  ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        textTheme: GoogleFonts.quicksandTextTheme(),
        useMaterial3: true
      ),
      routes: {
        "/home" : (context) => HomePage(),
      },
      initialRoute: "/home",
    );
  } 
}