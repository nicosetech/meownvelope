import 'package:hive_flutter/adapters.dart';

part 'envelope_data.g.dart';

@HiveType(typeId: 0)
class EnvelopeData extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int color;

  @HiveField(2)
  String? serverEnvID;

  @HiveField(3)
  double budgetTarget;

  @HiveField(4)
  double balance;

  @HiveField(5)
  int displayOrder;

  @HiveField(6)
  Map<int, String> users;

  EnvelopeData({
    required this.name,
    required this.color,
    required this.budgetTarget,
    required this.balance,
    required this.displayOrder,
    required this.serverEnvID,
    required this.users,
  });

  @override
  String toString() {
    return "EnvelopeData(name: $name, color: $color, serverEnvID: $serverEnvID, budgetTarget: $budgetTarget, balance: $balance, displayOrder: $displayOrder, users: $users)";
  }
}
