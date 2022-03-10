import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:assessment_task/model/user_scanner.dart';

class DatabaseHelper{
  final String userTable = 'user_scanner';
  final String columnId = 'id';
  final String columnUserFirstName = 'firstname';
  final String columnLastName = 'lastname';
  final String columnEmail = 'email';

  Future<Database> get db async{
    var _db = await intDB();
    return _db;
  }
  intDB() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path , 'mydb.db');
    var myOwnDB = await openDatabase(path,version: 1,
        onCreate:(Database db , int newVersion) async{
          var sql = "CREATE TABLE $userTable ($columnId INTEGER PRIMARY KEY,"
              " $columnUserFirstName TEXT, $columnLastName TEXT,  $columnEmail TEXT)";
          await db.execute(sql);
        });
    return myOwnDB;
  }
  Future<int> saveUser( Userscan user) async{
    var dbClient = await  db;
    int result = await dbClient.insert("$userTable", user.toMap());
    return result;
  }
  Future<List<Userscan>> getListUser() async {
    // Get a reference to the database.
    final dbList = await db;

    final List<Map<String, dynamic>> maps = await dbList.query("$userTable");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Userscan(maps[i]['id'],maps[i]['firstname'],maps[i]['lastname'],maps[i]['email']);
    });
  }
  Future<List> getAllUsers() async{
    var dbClient = await  db;
    var sql = "SELECT * FROM $userTable";
    List result = await dbClient.rawQuery(sql);
    return result.toList();
  }
}