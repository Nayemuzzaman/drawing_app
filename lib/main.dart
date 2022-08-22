import 'package:drawing_app/provider/paint_provider.dart';
import 'package:drawing_app/screens/painting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:(context) =>  PaintProvider(),
          )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PaintingScreen(),
      ),
      
    );
  }
}
