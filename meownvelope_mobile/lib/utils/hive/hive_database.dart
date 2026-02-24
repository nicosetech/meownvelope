import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabase{
  static void initHiveDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    final envelopes = await Hive.openBox("envelopes");
    // envelopes.put(124, {"name": "rent", "amount": 500});

    print(envelopes);

    print(envelopes.get(124));

    print("test");

  }
}