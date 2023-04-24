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
      onCreate: (db, version) async {
        //如果数据库不存在则创建
        return db.execute("""
        create table if not exists clipboard_txt
        (
            id         text              not null,
            user_id    text              not null,
            is_collect integer default 0 not null,
            txt        text              not null
        );
        
        create table if not exists folder
        (
            id                 TEXT not null
                constraint pk
                    primary key,
            folder_name        TEXT not null,
            before_folder_name TEXT not null,
            group_name         TEXT not null,
            user_id            text not null
        );
        
        create table if not exists folder_file
        (
            id          TEXT                      not null
                constraint pk
                    primary key,
            user_id     TEXT                      not null,
            group_name  TEXT                      not null,
            file_name   TEXT                      not null,
            folder_name text                      not null,
            upload_time integer default TIMESTAMP not null
        );
        
        create table if not exists groups
        (
            id         text not null
                constraint pk
                    primary key,
            user_id    text not null,
            group_name text not null
        );
        
        create table if not exists sqlite_master
        (
            type     TEXT,
            name     TEXT,
            tbl_name TEXT,
            rootpage INT,
            sql      TEXT
        );
        
        create table if not exists sqlite_sequence
        (
            name,
            seq
        );
        
        create table if not exists users
        (
            id     TEXT not null,
            token  TEXT not null,
            is_use int  not null
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
