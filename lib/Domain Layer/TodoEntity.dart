import 'package:hive/hive.dart';

part 'TodoEntity.g.dart';

@HiveType(typeId: 0)
class TodoEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime expiryTime; 

  TodoEntity({
    required this.id,
    required this.title,
    required this.expiryTime,
  });
}
