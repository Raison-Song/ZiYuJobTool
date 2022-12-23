import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;

class DBManager {
  // late Future<Database> _database;
  Future<Database> initDBManager() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory
      databaseFactory = databaseFactoryFfi;
    }

    return openDatabase(
      path.join(await getDatabasesPath(), 'identifier.sqlite'),
      onCreate: (db, version) async  {
        //如果数据库不存在则创建
        return db.execute("""
        create table if not exists dogs (
          id INTEGER PRIMARY KEY autoincrement,
          `name` TEXT NOT NULL
        );

        create table if not exists users (
          id TEXT NOT NULL,
          token TEXT NOT NULL,
          is_use INT NOT NULL
        );

        create table if not exists groups (
          id TEXT NOT NULL CONSTRAINT pk PRIMARY KEY,
          user_id TEXT NOT NULL,
          group_name TEXT NOT NULL
        );

        create table if not exists folder_file (
          id TEXT NOT NULL CONSTRAINT pk PRIMARY KEY,
          user_id TEXT NOT NULL,
          group_id TEXT NOT NULL,
          file_name TEXT NOT NULL
        );

        CREATE UNIQUE INDEX if not exists READ ON folder_file (group_name);

        create table if not exists folder (
          id TEXT NOT NULL CONSTRAINT pk PRIMARY KEY,
          folder_name TEXT NOT NULL,
          before_folder_name TEXT NOT NULL
        );
       """);
      },
      version: 3,
    );
  }

  Future<Database> getDatabase() async {
    return await initDBManager();
  }

}
