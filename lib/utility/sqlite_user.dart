

import 'package:sqflite/sqflite.dart';
import 'package:wesafe/models/mastWorkListDB_Model.dart';
import 'package:path/path.dart';
import 'package:wesafe/models/user_Model.dart';

class SQLiteHelperUserProfile {
  final String nameDatabase = 'wesafe.db';
  final int version = 1;
  final String nameUserTable = 'mastUserProfile';
  final String columnUserID = 'userID';
  final String columnFirstName = 'firstName';
  final String columnLastName = 'lastName';
  final String columnPosition = 'position';
  final String columnDeptCode = 'deptCode';
  final String columnTeamName = 'teamName';
  final String columnLeaderName = 'leaderName';
  final String columnPincode = 'pincode';
  final String columnCreatedDate = 'createdDate';

  SQLiteHelperUserProfile() {
    initailDatabase();
  }

  Future<Null> initailDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      version: version,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE $nameUserTable ( ' +
            ' $columnUserID TEXT PRIMARY KEY,' +
            ' $columnFirstName TEXT,' +
            ' $columnLastName TEXT,' +
            ' $columnPosition TEXT,' +
            ' $columnDeptCode TEXT,' +
            ' $columnTeamName INTEGER,' +
            ' $columnLeaderName INTEGER,' +
            ' $columnPincode TEXT,' +
            ' $columnCreatedDate TEXT' +
            ')',
      ),
    );
  }


 

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertDatebase(MastWorkListModel masterWorkListModel) async {
   Map<String, dynamic> maps = masterWorkListModel.toMap();

   print("#### insert ${maps.values}");



    Database database = await connectedDatabase();
    try {
      database.insert(
        nameUserTable,
        masterWorkListModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('######## insert database SQLite success');
    } catch (e) {}
  }

  Future<List<MastWorkListModel>> readDatabase() async {
  Database database = await connectedDatabase();
  List<MastWorkListModel> models = [];
  List<Map<String, dynamic>> maps = await database.query(nameUserTable);

    for (var item in maps) {
      MastWorkListModel model = MastWorkListModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<Null> deleteSQLiteAll() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(nameUserTable);
      print('====> delete success');
    } catch (e) {}
  }

  Future<Null> updatePinCode(UserModel userModel)async{
    Map<String, dynamic> maps = userModel.toJson();
  Database database = await connectedDatabase();
    try {
      await database.update(nameUserTable,maps,where: '');
      
    } catch (e) {}

  }


} //class
