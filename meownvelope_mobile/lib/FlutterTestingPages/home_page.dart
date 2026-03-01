import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';

class MeownvelopeApp extends StatelessWidget {
  const MeownvelopeApp({super.key});
  static const Color darkerBlue = Color.fromARGB(255, 49, 102, 128); 
  static const Color medBlue =Color.fromARGB(255, 186, 210, 229);
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
                title: Text("Meownvelope", style: GoogleFonts.mochiyPopPOne(textStyle: TextStyle(fontSize: 35))),
                leadingWidth: 90,
                leading: Image.asset('assets/cat_paw.png', color: darkerBlue),
                foregroundColor: darkerBlue,
                elevation: 0,
          ),
          //button at bottom right for new envelope
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: medBlue, 
            shape: RoundedRectangleBorder( 
                borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                icon: Icon(Icons.add, color: darkerBlue, size: 40),
                label:Icon(Icons.mail_outline, color: darkerBlue, size: 40),
                onPressed: (){Text('pressed');}, //temporary until button is linked to envelope creation page
          ),  
          
          //page layout
          body: Column(
            children: [
              //top section to include menu button, cash visual, and buttons
              Column(
                children:[
                  SizedBox(width: 30, height:30), // for space between sections
                  // menu button
                  Row(
                    children: [
                        Ink(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            color:medBlue, 
                            borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))),
                        child: IconButton(
                            icon: Icon(Icons.keyboard_double_arrow_right, color:darkerBlue, size: 60),
                            onPressed:(){ Text('pressed');}, // temporary until creation of menu bar
                            ),
                        ),
                    ]
                  ),
                  // cash visual
                  Container(
                    width: 150, 
                    height:160,
                    padding: EdgeInsets.only(bottom: 30,top:100, left:15, right:15),
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: medBlue,
                            borderRadius: BorderRadius.all(Radius.elliptical(80,50))
                        )
                    ),
                  ), 
                  // buttons for importing and filling
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        TextButton(
                            style: TextButton.styleFrom(
                                maximumSize: Size(180,70),
                                minimumSize: Size(130,50),
                                elevation: 5,
                                shadowColor: medBlue,
                                backgroundColor: darkerBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    )
                                ),
                            child: Text("Import Funds", style: GoogleFonts.martianMono(textStyle: TextStyle(height: 2, fontSize: 17))),
                            onPressed:(){ Text('pressed');} //temp until import funds page is made
                        ), 
                        TextButton(
                            style: TextButton.styleFrom(
                                maximumSize: Size(180,70),
                                minimumSize: Size(130,50),
                                elevation: 5,
                                shadowColor: medBlue,
                                backgroundColor: darkerBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    )
                                ),
                            child: Text("Fill Envelopes", style: GoogleFonts.martianMono(textStyle: TextStyle(height: 2, fontSize: 15))),
                            onPressed:(){ Text('pressed');}, //temp until fill envelopes page is made
                        )
                    ]
                  )
                ]
              ), 
              // bottom section that shows envelope previews 
              SizedBox(width: 30, height:50), // for space between top and bottom sections
              Container( //background box containing envelope list
                height: 450,
                width: 380,
                color: lightestBlue,

                child: GridView.count( // container that actually holds envelopes
                  crossAxisCount: 2,
                  children: [
                    envelopeBuilder(Colors.white, "Groceries")
                  ],
                ),
              )
            ]
          )
        )
        );
  }
  Widget envelopeBuilder(Color userColor, String userLabel) {
    return Container(
        color: userColor,
        margin: EdgeInsets.only(bottom:30,top:40, left:10, right:10),
        child: Stack(
        alignment: Alignment.center,
        children: [ Image.asset('assets/envelope.png'),
        Positioned(top:25, child: Text(userLabel, style: TextStyle(fontSize: 15)))
        ]
        ),
    );
  } 
}