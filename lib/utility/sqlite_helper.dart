

import 'package:sqflite/sqflite.dart';
import 'package:wesafe/models/mastWorkListDB_Model.dart';
import 'package:path/path.dart';
import 'package:wesafe/models/user_Model.dart';

class SQLiteHelperWorkList {
  final String nameDatabase = 'wesafe.db';
  final String nameTable = 'worklist';
  final int version = 1;
  final String columnworkID = 'workID';
  final String columnuserID = 'userID';
  final String columnrsg = 'rsg';
  final String columnownerID = 'ownerID';
  final String columnmainWorkID = 'mainWorkID';
  final String columnsubWorkID = 'subWorkID';
  final String columnChecklistID = 'checklistID';
  final String columnLat = 'lat';
  final String columnLng = 'lng';
  final String columnWorkPerform = 'workPerform';
  final String columnRemark = 'remark';
  final String columnIsChoice = 'isChoice';
  final String columnReason = 'reason';
  final String columnMsgFromWeb = 'msgFromWeb';
  final String columnPinCode = 'pincode';
  final String columnCreateDate = 'createDate';
  final String columnUploadDate = 'uploadDate';

  SQLiteHelperWorkList() {
    initailDatabase();
  }

  Future<Null> initailDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      version: version,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE $nameTable ( ' +
            ' $columnworkID INTEGER PRIMARY KEY,' +
            ' $columnuserID TEXT,' +
            ' $columnrsg TEXT,' +
            ' $columnownerID TEXT,' +
            ' $columnmainWorkID TEXT,' +
            ' $columnsubWorkID INTEGER,' +
            ' $columnChecklistID INTEGER,' +
            ' $columnLat TEXT,' +
            ' $columnLng TEXT, ' +
            ' $columnWorkPerform TEXT, ' +
            ' $columnRemark TEXT, ' +
            ' $columnIsChoice INTEGER, ' +
            ' $columnReason TEXT, ' +
            ' $columnPinCode TEXT, ' +
            ' $columnMsgFromWeb TEXT, ' +
            ' $columnCreateDate TEXT, ' +
            ' $columnUploadDate TEXT ' +
            ')',
      ),
    );
  }


  Future<Null> initailUserProfileDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      version: version,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE $nameTable ( ' +
            ' $columnworkID INTEGER PRIMARY KEY,' +
            ' $columnuserID TEXT,' +
            ' $columnrsg TEXT,' +
            ' $columnownerID TEXT,' +
            ' $columnmainWorkID TEXT,' +
            ' $columnsubWorkID INTEGER,' +
            ' $columnChecklistID INTEGER,' +
            ' $columnLat TEXT,' +
            ' $columnLng TEXT, ' +
            ' $columnWorkPerform TEXT, ' +
            ' $columnRemark TEXT, ' +
            ' $columnIsChoice INTEGER, ' +
            ' $columnReason TEXT, ' +
            ' $columnPinCode TEXT, ' +
            ' $columnMsgFromWeb TEXT, ' +
            ' $columnCreateDate TEXT, ' +
            ' $columnUploadDate TEXT ' +
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
        nameTable,
        masterWorkListModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('######## insert database SQLite success');
    } catch (e) {}
  }

  Future<List<MastWorkListModel>> readDatabase() async {
  Database database = await connectedDatabase();
  List<MastWorkListModel> models = [];
  List<Map<String, dynamic>> maps = await database.query(nameTable);

    for (var item in maps) {
      MastWorkListModel model = MastWorkListModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<Null> deleteSQLiteAll() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(nameTable);
      print('====> delete success');
    } catch (e) {}
  }

  Future<Null> updatePinCode(UserModel userModel)async{
    Map<String, dynamic> maps = userModel.toJson();
  Database database = await connectedDatabase();
    try {
      await database.update(nameTable,maps,where: '');
      
    } catch (e) {}

  }




  /************************** */
  Future<Null> dropDB()async{
     Database database = await connectedDatabase();
     try {
    await  database.execute('DROP TABLE $nameTable');
     }catch(e){
      print("#######  dropDB()  error r : "+e.toString());
     }
  }

} //class
