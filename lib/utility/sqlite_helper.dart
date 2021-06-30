import 'package:sqflite/sqflite.dart';
import 'package:wesafe/models/MastWorkListModel.dart';
import 'package:path/path.dart';
import 'package:wesafe/models/UserModel.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/my_constainDB.dart';

class SQLiteHelperWorkList {
  
  final int version = 1;

  SQLiteHelperWorkList() {
    initailDatabase();
  }

  Future<Null> initailDatabase() async {
    var databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, MyConstant.nameDatabase);
    await openDatabase(path, version: 1,
        onCreate: (Database database, int version) async {
      await database.execute('CREATE TABLE ${MyConstainWorklistDB.nameTable} ( ' +
          ' ${MyConstainWorklistDB.columnworkID} INTEGER PRIMARY KEY,' +
          ' ${MyConstainWorklistDB.columnuserID} TEXT,' +
          ' ${MyConstainWorklistDB.columnrsg} TEXT,' +
          ' ${MyConstainWorklistDB.columnownerID} TEXT,' +
          ' ${MyConstainWorklistDB.columnmainWorkID} TEXT,' +
          ' ${MyConstainWorklistDB.columnsubWorkID} INTEGER,' +
          ' ${MyConstainWorklistDB.columnChecklistID} INTEGER,' +
          ' ${MyConstainWorklistDB.columnLat} TEXT,' +
          ' ${MyConstainWorklistDB.columnLng} TEXT, ' +
          ' ${MyConstainWorklistDB.columnWorkPerform} TEXT, ' +
          ' ${MyConstainWorklistDB.columnRemark} TEXT, ' +
          ' ${MyConstainWorklistDB.columnIsChoice} INTEGER, ' +
          ' ${MyConstainWorklistDB.columnReason} TEXT, ' +
          ' ${MyConstainWorklistDB.columnPinCode} TEXT, ' +
          ' ${MyConstainWorklistDB.columnMsgFromWeb} TEXT, ' +
          ' ${MyConstainWorklistDB.columnCreateDate} TEXT, ' +
          ' ${MyConstainWorklistDB.columnUploadDate} TEXT ' +
          ')');

      await database.execute('CREATE TABLE ${MyConstainUserProfileDB.nameUserTable} ( ' +
          ' ${MyConstainUserProfileDB.columnUserID} TEXT PRIMARY KEY,' +
          ' ${MyConstainUserProfileDB.columnFirstName} TEXT,' +
          ' ${MyConstainUserProfileDB.columnLastName} TEXT,' +
          ' ${MyConstainUserProfileDB.columnPosition} TEXT,' +
          ' ${MyConstainUserProfileDB.columnDeptCode} TEXT,' +
          ' ${MyConstainUserProfileDB.columnTeamName} TEXT,' +
          ' ${MyConstainUserProfileDB.columnLeaderName} TEXT,' +
          ' ${MyConstainUserProfileDB.columnPincode} TEXT,' +
          ' ${MyConstainUserProfileDB.columnCreatedDate} TEXT ' +
          ')');

          
    });
    // print("###### init 1 ");
    // await openDatabase(
    //   join(await getDatabasesPath(), nameDatabase),
    //   version: version,
    //   onCreate: (db, version) => db.execute(
    //     'CREATE TABLE $nameTable ( ' +
    //         ' $columnworkID INTEGER PRIMARY KEY,' +
    //         ' $columnuserID TEXT,' +
    //         ' $columnrsg TEXT,' +
    //         ' $columnownerID TEXT,' +
    //         ' $columnmainWorkID TEXT,' +
    //         ' $columnsubWorkID INTEGER,' +
    //         ' $columnChecklistID INTEGER,' +
    //         ' $columnLat TEXT,' +
    //         ' $columnLng TEXT, ' +
    //         ' $columnWorkPerform TEXT, ' +
    //         ' $columnRemark TEXT, ' +
    //         ' $columnIsChoice INTEGER, ' +
    //         ' $columnReason TEXT, ' +
    //         ' $columnPinCode TEXT, ' +
    //         ' $columnMsgFromWeb TEXT, ' +
    //         ' $columnCreateDate TEXT, ' +
    //         ' $columnUploadDate TEXT ' +
    //         ')',
    //   ),
    // );
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), MyConstant.nameDatabase));
  }

  Future<Null> insertDatebase(MastWorkListModel masterWorkListModel) async {
    Map<String, dynamic> maps = masterWorkListModel.toMap();

    print("#### insert ${maps.values}");

    Database database = await connectedDatabase();
    try {
      database.insert(
        MyConstainWorklistDB.nameTable,
        masterWorkListModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('######## insert database SQLite success');
    } catch (e) {}
  }

  Future<Null> insertDatebase2(MastWorkListModel masterWorkListModel) async {
    Map<String, dynamic> maps = masterWorkListModel.toMap();

    print("#### insert ${maps.values}");

    Database database = await connectedDatabase();
    try {
      database.insert(
        "TEST1",
        masterWorkListModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('######## insert database SQLite success');
    } catch (e) {}
  }

  Future<List<MastWorkListModel>> readDatabase2() async {
    Database database = await connectedDatabase();
    List<MastWorkListModel> models = [];
    List<Map<String, dynamic>> maps = await database.query("TEST1");

    for (var item in maps) {
      MastWorkListModel model = MastWorkListModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<List<MastWorkListModel>> readDatabase() async {
    Database database = await connectedDatabase();
    List<MastWorkListModel> models = [];
    List<Map<String, dynamic>> maps = await database.query(MyConstainWorklistDB.nameTable);

    for (var item in maps) {
      MastWorkListModel model = MastWorkListModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<Null> deleteSQLiteAll() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(MyConstainWorklistDB.nameTable);
      print('====> delete success');
    } catch (e) {}
  }

  Future<Null> updatePinCode(UserModel userModel) async {
    Map<String, dynamic> maps = userModel.toJson();
    Database database = await connectedDatabase();
    try {
      await database.update(MyConstainWorklistDB.nameTable, maps, where: '');
    } catch (e) {}
  }

  /************************** */
  Future<Null> dropDB() async {
    Database database = await connectedDatabase();
    try {
      await database.execute('DROP TABLE ${MyConstainWorklistDB.nameTable}');
    } catch (e) {
      print("#######  dropDB()  error r : " + e.toString());
    }
  }
} //class
