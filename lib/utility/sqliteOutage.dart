import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wesafe/models/sqliteWorklistOutageModel.dart';
import 'package:wesafe/utility/my_constain.dart';

class SQLiteHelperOutage {
  final int version = 1;

  SQLiteHelperOutage() {
    initailDatabase();
  }

  Future<Null> initailDatabase() async {
    //var databasesPath = await getDatabasesPath();
    //final String path = join(databasesPath, MyConstant.nameDatabase);
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(
        join(await getDatabasesPath(), MyConstant.nameDatabase));
  }

  //------------------------- WORLIST -----------------------------------//
  Future<Null> insertWorkList(
      SQLiteWorklistOutageModel sqLiteWorklistModel) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        'WORKLIST',
        sqLiteWorklistModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('######## insert WORKLIST SQLite success');
    } catch (e) {
      print('insert error : ' + e);
    }
  } //insert

  Future<List<SQLiteWorklistOutageModel>> readWorkList() async {
    Database database = await connectedDatabase();
    List<SQLiteWorklistOutageModel> models = [];
    List<Map<String, dynamic>> maps = await database.query('WORKLIST');

    for (var item in maps) {
      SQLiteWorklistOutageModel model = SQLiteWorklistOutageModel.fromMap(item);
      models.add(model);
    }

    return models;
  }
} //class
