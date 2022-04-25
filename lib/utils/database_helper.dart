import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:assessment_task/model/user_scanner.dart';

class DatabaseHelper{
  final String userTable = 'info_user';
  final String brouillonTable = 'brouillon_user';
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
  final String created='created';
  final String updated='updated';
  Future<Database> get db async{
    var _db = await intDB();
    return _db;
  }
  intDB() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path , 'datascanner.db');
    var myOwnDB = await openDatabase(path,version: 1,
        onCreate:(Database db , int newVersion) async{
      Batch batch= db.batch();
          var sql = "CREATE TABLE $brouillonTable ($columnId INTEGER  auto_increment,"
              " $columnUserFirstName TEXT, $columnLastName TEXT,$company TEXT,"
              " $columnEmail TEXT,$phone TEXT,$adresse TEXT,$evolution TEXT,"
              "$action TEXT,$notes TEXT,$created TEXT,$updated TEXT)";
          var sql1 = "CREATE TABLE $userTable ($columnId INTEGER  auto_increment,"
              " $columnUserFirstName TEXT, $columnLastName TEXT,$company TEXT,"
              " $columnEmail TEXT,$phone TEXT,$adresse TEXT,$evolution TEXT,"
              "$action TEXT,$notes TEXT,$created TEXT,$updated TEXT)";
            db.execute(sql);
            db.execute(sql1);
      await  batch.commit();
        });
    return myOwnDB;
  }
  //save user
  Future<int> saveUser( Userscan user) async{
    var dbClient = await  db;
    int result = await dbClient.insert("$userTable", user.toMap());
    return result;
  }
  //save to Brouillon
  Future<int> saveBrouillon( Userscan user) async{
    var dbClient = await  db;
    int result = await dbClient.insert("$brouillonTable", user.toMap());
    return result;
  }
  //get list of users
  Future<List<Userscan>> getListUser() async {
    final dbList = await db;
    final List<Map<String, dynamic>> maps = await dbList.query("$userTable");
    return List.generate(maps.length, (i) {
      return Userscan(maps[i]['firstname'],maps[i]['lastname'],maps[i]['company'],maps[i]['email'],maps[i]['phone'],maps[i]['adresse'],maps[i]['evolution'],maps[i]['action'],maps[i]['notes'],maps[i]['created'],maps[i]['updated']);
    });
  }
  //get list of brouillon
  Future<List<Userscan>> getListBrouillon() async {
    final dbList = await db;
    final List<Map<String, dynamic>> maps = await dbList.query("$brouillonTable");
    return List.generate(maps.length, (i) {
      return Userscan(maps[i]['firstname'],maps[i]['lastname'],maps[i]['company'],maps[i]['email'],maps[i]['phone'],maps[i]['adresse'],maps[i]['evolution'],maps[i]['action'],maps[i]['notes'],maps[i]['created'],maps[i]['updated']);
    });
  }
  // select all users
  Future<List> getAllUsers() async{
    var dbClient = await  db;
    var sql = "SELECT * FROM $userTable";
    List result = await dbClient.rawQuery(sql);
    return result.toList();
  }
  //get user by email
  Future<dynamic> getUsersByemail(String email) async{
    var dbClient = await  db;
    //var sql = "SELECT * FROM $userTable WHERE $columnEmail='$email'";
    var result =await dbClient.query(userTable,where: "$columnEmail = ?" , whereArgs: [email]);
    return result;
  }
  //select all Brouillon
  Future<List> getAllBrouillon() async{
    var dbClient = await  db;
    var sql = "SELECT * FROM $brouillonTable";
    List result = await dbClient.rawQuery(sql);
    return result.toList();
  }
  // delete user to Brouillon
  Future<int> deleteUser(String email,Userscan user) async{
    var dbClient = await  db;
    saveBrouillon(user);
    return
      await dbClient.delete(
        userTable , where: "$columnEmail = ?" , whereArgs: [email]
    );
  }
  //delete Brouillon
  Future<int> deleteBrouillon(String email) async{
    var dbClient = await  db;
    return
      await dbClient.delete(
          brouillonTable , where: "$columnEmail = ?" , whereArgs: [email]
      );
  }
  //delete user for sync
  Future<int> deleteTosync() async{
    var dbClient = await  db;
    return
      await dbClient.delete(userTable);
  }
  //update user
  Future<int> updateUser(Userscan user,String email) async{
    var dbClient = await  db;
    int result = await dbClient.update("$userTable", user.toMap(),where: "$columnEmail = ?" , whereArgs: [email]);
    return result;
  }
  //update brouillon
  Future<int> updateUserBrouillon(Userscan user,String email) async{
    var dbClient = await  db;
    int result = await dbClient.update("$brouillonTable", user.toMap(),where: "$columnEmail = ?" , whereArgs: [email]);
    return result;
  }
  //restore user
  Future<int> restoreUser(String email,Userscan user) async{
    var dbClient = await  db;
    saveUser(user);
    return
      await dbClient.delete(
          brouillonTable , where: "$columnEmail = ?" , whereArgs: [email]
      );
  }
}