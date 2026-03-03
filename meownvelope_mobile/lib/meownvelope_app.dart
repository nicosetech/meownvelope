import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meownvelope_mobile/DataTypes/envelope_data.dart';
import 'package:meownvelope_mobile/envelope_creation_page.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:meownvelope_mobile/meownvelope_colors.dart';

class MeownvelopeApp extends StatefulWidget {
  const MeownvelopeApp({super.key});
  
  @override
  State<MeownvelopeApp> createState() => _MeownvelopeAppState();
}

class _MeownvelopeAppState extends State<MeownvelopeApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: MeownvelopeColors.bgColor,
            // bar to display title and paw icon
            appBar: AppBar(
                backgroundColor: MeownvelopeColors.bgColor,
                title: Text("Meownvelope", style: GoogleFonts.mochiyPopPOne(textStyle: TextStyle(fontSize: 35))),
                leadingWidth: 90,
                leading: Image.asset('assets/cat_paw.png', color:MeownvelopeColors.darkBlue),
                foregroundColor: MeownvelopeColors.darkBlue,
                elevation: 0,
          ),
          //button at bottom right for new envelope
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: MeownvelopeColors.lightBlue, 
            shape: RoundedRectangleBorder( 
                borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                icon: Icon(Icons.add, color: MeownvelopeColors.darkBlue, size: 40),
                label:Icon(Icons.mail_outline, color: MeownvelopeColors.darkBlue, size: 40),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const EnvelopeCreationPage(),))
                           .then((value) {
                              setState(() {});
                            },
                          );
                },
          ),  
          
          //page layout
          body: Column(
            spacing: 40,
            children: [
              //top section to include menu button, cash visual, and buttons
              Column(
                children:[
                  SizedBox(width: 30, height:20), // for space between sections
                  // menu button
                  Row(
                    children: [
                        Ink(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            color:MeownvelopeColors.lightBlue, 
                            borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))),
                        child: IconButton(
                            icon: Icon(Icons.keyboard_double_arrow_right, color:MeownvelopeColors.darkBlue, size: 60),
                            onPressed:(){ Text('pressed');}, // temporary until creation of menu bar
                            ),
                        ),
                    ]
                  ),
                  // cash visual
                  Stack(
                    alignment: AlignmentGeometry.centerStart,
                        children: [
                            Align(alignment: Alignment.bottomCenter, child: ClipOval(child: Container(width: 180, height: 60, decoration: BoxDecoration(color:MeownvelopeColors.lightBlue)))
                            ),
                            Align(alignment: Alignment.center, child: Image.asset('assets/leastcash.png',width:150, height:120)),
                        ] 
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
                                shadowColor: MeownvelopeColors.lightBlue,
                                backgroundColor: MeownvelopeColors.darkBlue,
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
                                shadowColor: MeownvelopeColors.lightBlue,
                                backgroundColor: MeownvelopeColors.darkBlue,
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
              //SizedBox(width: 30, height:50), // for space between top and bottom sections
              Container( //background box containing envelope list
                height: 450,
                width: 380,
                color: MeownvelopeColors.secondaryBgColor,

                child: GridView.count( // container that actually holds envelopes
                  crossAxisCount: 2,
                  children: envelopeList()
                    //envelopeBuilder(Colors.white, "Groceries")
                ),
              )
            ]
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

  List<Widget> envelopeList(){
    List<EnvelopeData> sortedEnvelopes = HiveDatabase.getEnvelopes().values.toList();
    sortedEnvelopes.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    List<Widget> envList = [];
    for (var envelope in sortedEnvelopes){
      envList.add(envelopeBuilder(Color(envelope.color), envelope.name));
    }
   //envList.sort();
    return envList;
  }
}