import 'package:assessment_task/model/user_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database_user = openDatabase(
    join(await getDatabasesPath(),'database_user_scanner.db'),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE user_scanner(id INT PRIMARY KEY,firstname TEXT,lastname TEXT,email TEXT)");
    },
    version: 1,
  );
  //insert
  Future<void> insertUser(Userscan user) async{
    final Database db = await database_user;
    await db.insert('user_scanner', user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  //select
  Future<List<Userscan>> usersscan() async {
    final Database db = await database_user;
    final List<Map<String, dynamic>> maps=await db.query('user_scanner');
    return List.generate(maps.length, (i){
      return Userscan(maps[i]['id'], maps[i]['firstname'], maps[i]['lastname'], maps[i]['email']);
    });
  }
}