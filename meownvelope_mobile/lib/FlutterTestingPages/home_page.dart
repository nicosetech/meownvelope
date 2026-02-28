import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';

class MeownvelopeApp extends StatelessWidget {
  const MeownvelopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          // bar to display title and paw icon
          appBar: AppBar(),
          //button at bottom right for new envelope
          floatingActionButton: FloatingActionButton(),  
          
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