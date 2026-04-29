import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data/services/api/websocket_client.dart';
import 'package:meownvelope_mobile/data/services/recurring_deposit_service.dart';
import 'package:meownvelope_mobile/home_page_viewer.dart';
import 'package:meownvelope_mobile/utils/styling/easy_loading_customize.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:meownvelope_mobile/utils/widgets/badge_unlock_listener.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.initHiveDatabase();
  await RecurringDepositService.processRecurringDeposits();
  WebsocketClient.initializeWebsocket();

  runApp(
    MaterialApp(
      builder: EasyLoadingCustomize.initCustomEasyLoading(),
      home: BadgeUnlockListener(child: HomePageViewer()),
    ),
  );
}
