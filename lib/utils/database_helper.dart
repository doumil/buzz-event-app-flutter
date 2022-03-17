import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:assessment_task/model/user_scanner.dart';

class DatabaseHelper{
  final String userTable = 'info_user';
  final String columnId = 'id';
  final String columnUserFirstName = 'firstname';
  final String columnLastName = 'lastname';
  final String company='company';
  final String columnEmail = 'email';
  final String phone='phone';
  final String adresse= 'adresse';
  final String evolution= 'evolution';
  final String action= 'action';
  final String notes= 'notes';

  Future<Database> get db async{
    var _db = await intDB();
    return _db;
  }
  intDB() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path , 'datascanner.db');
    var myOwnDB = await openDatabase(path,version: 1,
        onCreate:(Database db , int newVersion) async{
          var sql = "CREATE TABLE $userTable ($columnId INTEGER  auto_increment,"
              " $columnUserFirstName TEXT, $columnLastName TEXT,$company TEXT,"
              " $columnEmail TEXT,$phone TEXT,$adresse TEXT,$evolution TEXT,"
              "$action TEXT,$notes TEXT)";
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
      return Userscan(maps[i]['firstname'],maps[i]['lastname'],maps[i]['company'],maps[i]['email'],maps[i]['phone'],maps[i]['adresse'],maps[i]['evolution'],maps[i]['action'],maps[i]['notes']);
    });
  }
  Future<List> getAllUsers() async{
    var dbClient = await  db;
    var sql = "SELECT * FROM $userTable";
    List result = await dbClient.rawQuery(sql);
    return result.toList();
  }
  Future<int> deleteUser(String email) async{
    var dbClient = await  db;
    return  await dbClient.delete(
        userTable , where: "$columnEmail = ?" , whereArgs: [email]
    );
  }
}