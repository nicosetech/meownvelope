import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';

class MeownvelopeApp extends StatelessWidget {
  const MeownvelopeApp({super.key});
  static const Color darkerBlue = Color.fromARGB(255, 84, 115, 141); 
  static const Color medBlue = Color.fromARGB(255, 183, 203, 220); 
  static const Color lighterBlue = Color.fromARGB(255, 206, 221, 233); 
  static const Color lightestBlue = Color.fromARGB(255, 222, 232, 239); 
  static const Color backgroundBlue = Color.fromARGB(255, 230, 237, 241); 
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: backgroundBlue,
            // bar to display title and paw icon
            appBar: AppBar(
                backgroundColor: backgroundBlue,
                title: const Text("Meownvelope"),
                leading: Icon(Icons.pets),
                foregroundColor: darkerBlue,
                elevation: 0,
          ),
          //button at bottom right for new envelope
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: medBlue, 
            shape: RoundedRectangleBorder( 
                borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                icon: Icon(Icons.add, color: darkerBlue),
                label:Icon(Icons.mail_outline, color: darkerBlue),
                onPressed: (){Text('pressed');}, //temporary until button is linked to envelope creation page
          ),  
          
          //page layout
          body: Column(
            children: [
              //top section to include menu button, cash visual, and buttons
              Column(
                children:[
                  // menu button
                  Row(),
                  // cash visual
                  Container(), 
                  // buttons for importing and filling
                  Row(
                    children: [ TextButton(), TextButton()]
                  )
                ]
              ), 
              // bottom section that shows envelope previews 
              Container()
            ]
          )
        )
        );
  }
}