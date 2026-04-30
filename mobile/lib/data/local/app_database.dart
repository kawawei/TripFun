/**
 * @file app_database.dart
 * @description Drift 資料庫定義 / Drift database definition
 * @description_zh 定義 SQLite 資料表架構與資料庫實例，替代 Isar 以支援 Android 16 16KB 頁對齊
 * @description_en Defines SQLite table schemas and database instance, replacing Isar for Android 16 16KB support
 */

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DataClassName('Trip')
class Trips extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().unique()();
  TextColumn get title => text()();
  TextColumn get location => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get memberCount => integer()();
  TextColumn get status => text()();
  TextColumn get iconName => text().nullable()();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
}

@DataClassName('Activity')
class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().unique()();
  TextColumn get tripId => text()();
  TextColumn get title => text()();
  TextColumn get subtitle => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get type => text()();
  TextColumn get time => text()();
  IntColumn get sortOrder => integer()();
  TextColumn get locationName => text().nullable()();
  TextColumn get iconName => text().nullable()();
  TextColumn get imageUrls => text().nullable()(); // 存放 JSON 字串
  TextColumn get personalInfoJson => text().nullable()(); // 存放 JSON 字串
  DateTimeColumn get lastUpdated => dateTime().nullable()();
}

@DataClassName('Expense')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().unique().nullable()();
  TextColumn get tripId => text()();
  RealColumn get amount => real()();
  TextColumn get currency => text()();
  RealColumn get amountInBaseCurrency => real()();
  TextColumn get category => text()();
  TextColumn get title => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

@DataClassName('Packing')
class Packings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().unique()();
  TextColumn get tripId => text().nullable()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  BoolColumn get isChecked => boolean()();
  BoolColumn get isCustom => boolean()();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
}

@DriftDatabase(tables: [Trips, Activities, Expenses, Packings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase(file);
    });
  }
}
