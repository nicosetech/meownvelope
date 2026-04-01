import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/pages/auth_pages/create_account_page.dart';
import 'package:meownvelope_mobile/home_page_viewer.dart';
import 'package:meownvelope_mobile/utils/styling/easy_loading_customize.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.initHiveDatabase();

  runApp(
    MaterialApp(
      builder: EasyLoadingCustomize.initCustomEasyLoading(),
      home: HomePageViewer(),
    ),
  );
}
