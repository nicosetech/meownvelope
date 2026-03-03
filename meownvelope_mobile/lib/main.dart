import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meownvelope_mobile/FlutterTestingPages/example_page.dart';
import 'package:meownvelope_mobile/envelope_creation_page.dart';
import 'package:meownvelope_mobile/meownvelope_app.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:path_provider/path_provider.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.initHiveDatabase();

  runApp(MaterialApp(home: MeownvelopeApp()));

  
}
