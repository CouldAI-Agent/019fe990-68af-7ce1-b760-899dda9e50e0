import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:ffi';
import 'package:sqlite3/sqlite3.dart';

part 'database.g.dart';

@DataClassName('Person')
class Persons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get militaryNumber => text().unique()();
  TextColumn get fullName => text()();
  TextColumn get point => text().nullable()();
  TextColumn get department => text().nullable()();
  TextColumn get teamGroup => text().nullable()();
  DateTimeColumn get joinDate => dateTime()();
  TextColumn get status => text().withDefault(const Constant('نشط'))();
  TextColumn get notes => text().nullable()();
}

@DataClassName('AttendanceRecord')
class Attendance extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personId => integer().references(Persons, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get status => text().withDefault(const Constant('حاضر'))();
  TextColumn get notes => text().nullable()();
}

@DriftDatabase(tables: [Persons, Attendance])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'hr_system.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
