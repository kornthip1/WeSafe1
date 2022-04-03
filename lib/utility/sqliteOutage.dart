import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wesafe/models/mastLables.dart';
import 'package:wesafe/models/sqliteWorklistOutageModel.dart';
import 'package:wesafe/utility/my_constain.dart';

import '../models/MastOutageMenuModel.dart';

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
      print('######## insert WORKLIST SQLite success : ' +
          sqLiteWorklistModel.reqNo);
    } catch (e) {
      print('insert error : ' + e);
    }

    // print("#####-----> " + result.length.toString());
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

  Future<int> selectLastID() async {
    Database database = await connectedDatabase();
    List<SQLiteWorklistOutageModel> models = [];
    //List<Map<String, dynamic>> maps = await database.query('WORKLIST',orderBy: 'REQNO');
    List<Map<String, dynamic>> maps = await database.rawQuery("SELECT REQNO " +
        "FROM  WORKLIST  WHERE length(REQNO)<5 " +
        "ORDER BY REQNO DESC  " +
        "LIMIT 1");

    for (var item in maps) {
      SQLiteWorklistOutageModel model = SQLiteWorklistOutageModel.fromMap(item);
      models.add(model);
    }
    int lastID = 1;
    if (models.length > 0) {
      for (var item in models) {
        lastID = int.parse(item.reqNo != null ? item.reqNo : "1") + 1;
      }
    }

    return lastID;
  }

  Future<List<SQLiteWorklistOutageModel>> selectWorkList(
      String reqNo, String subMenu) async {
    print('########### selectWorkList : $reqNo ,  $subMenu');
    Database database = await connectedDatabase();
    List<SQLiteWorklistOutageModel> models = [];
    List<Map<String, dynamic>> maps = await database.rawQuery("SELECT * " +
        "FROM  WORKLIST  WHERE REQNO = '$reqNo' AND  SUBMENU = '$subMenu' " +
        "ORDER BY REQNO DESC  ");

    for (var item in maps) {
      SQLiteWorklistOutageModel model = SQLiteWorklistOutageModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<List<SQLiteWorklistOutageModel>> selectWorkListForCheck() async {
    Database database = await connectedDatabase();
    List<SQLiteWorklistOutageModel> models = [];
    List<
        Map<String,
            dynamic>> maps = await database.rawQuery("SELECT DISTINCT REQNO, " +
        "CASE WHEN WORKSTATUS = 0 THEN '' " +
        "     WHEN WORKSTATUS = 2 THEN 'รอตรวจสอบ'" +
        "     WHEN WORKSTATUS = 3 THEN 'ไม่อนุมัติ'" +
        "     WHEN WORKSTATUS = 4 THEN 'อนุมัติแล้วยังไม่จบกระบวนการ (รอปิดงาน)'" +
        "     WHEN WORKSTATUS = 5 THEN 'ปิดงาน'" +
        "     END AS REMARK," +
        "     MAINMENU,"
            "     WORKSTATUS  , WORKPERFORM  " +
        "     FROM  WORKLIST WHERE ISCOMPLATE  != 1  AND MAINMENU != '999' AND WORKSTATUS != 0 " +
        "     ORDER BY REQNO DESC  ");

    //AND  ( WORKSTATUS = 4  OR WORKSTATUS = 5 )

    for (var item in maps) {
      SQLiteWorklistOutageModel model = SQLiteWorklistOutageModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  // update sent complete or not
  Future<Null> updateWorkListStatus(int status, String reqNo) async {
    Database database = await connectedDatabase();
    try {
      int count = await database.rawUpdate(
          'UPDATE  WORKLIST  ' + 'SET WORKSTATUS = ?  ' + 'WHERE REQNO = ? ',
          [status, '$reqNo']);

      print("###### updateWorkListStatus()  $status  update seccess $count   row");
    } catch (e) {
      print("########## update working()  Error : ${e.toString()}");
    }
  }

  Future<Null> deleteWorklistByReqNo(String reqNo) async {
    Database database = await connectedDatabase();
    try {
      int count = await database
          .rawUpdate('DELETE FROM  WORKLIST  WHERE REQNO = ? ', ['$reqNo']);

      print("###### DELETE()  update seccess $count   row");
    } catch (e) {
      print("########## DELETE working()  Error : ${e.toString()}");
    }
  }

  Future<Null> updateWorkList(
      int status,
      String reqNo,
      String subId,
      int checklist,
      String imglist,
      int doOrNot,
      String reasonNot,
      String workPerform,
      int isMainLine) async {
    Database database = await connectedDatabase();
    try {
      int count = await database.rawUpdate(
        'UPDATE  WORKLIST  ' +
            'SET WORKSTATUS = ? ,DOORNOT = ?, RESEANNOT = ?, IMGLIST = ? , WORKPERFORM = ? , ISMAINLINE = ? ' +
            'WHERE REQNO = ? AND SUBMENU = ? AND CHECKLIST = ?',
        [
          status,
          doOrNot,
          reasonNot,
          imglist,
          '$workPerform',
          isMainLine,
          '$reqNo',
          '$subId',
          checklist
        ],
      );

      print("###### updateWorkList()  update seccess $count   row");
    } catch (e) {
      print("########## update working()  Error : ${e.toString()}");
    }
  }

  Future<Null> updateWorkListReq(String oldReq, String newReq) async {
    Database database = await connectedDatabase();
    try {
      int count = await database.rawUpdate(
          'UPDATE  WORKLIST  ' +
              'SET REQNO = ? , WORKSTATUS =4  ' +
              'WHERE REQNO = ? ',
          ['$newReq', '$oldReq']);

      print(
          "###### updateWorkReqNo()  update req old -> $oldReq , new -> $newReq :  $count   row");
    } catch (e) {
      print("########## update working()  Error : ${e.toString()}");
    }
  }

  Future<Null> deleteWorkAllWorkList() async {
    Database database = await connectedDatabase();
    try {
      await database.delete('WORKLIST');
      print('====> delete work success');
    } catch (e) {}
  }

  /////////////----------- MENU
  Future<Null> insertMenu(MastOutageMenuModel menuModel) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        'LISTMENU',
        menuModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('######## insert MENU  success');
    } catch (e) {
      print('insert error : ' + e);
    }
  } //insert

  Future<List<MastOutageMenuModel>> readMenu() async {
    Database database = await connectedDatabase();
    List<MastOutageMenuModel> models = [];
    List<Map<String, dynamic>> maps = await database.query('LISTMENU');

    for (var item in maps) {
      MastOutageMenuModel model = MastOutageMenuModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<List<MastOutageMenuModel>> selectMainMenu(int mainID) async {
    Database database = await connectedDatabase();
    List<MastOutageMenuModel> models = [];
    //List<Map<String, dynamic>> maps = await database.query('WORKLIST',orderBy: 'REQNO');
    List<Map<String, dynamic>> maps = await database.rawQuery(
        "SELECT DISTINCT MENUMAIN_ID,MENUMAIN_NAME " +
            "FROM  LISTMENU  " +
            "WHERE CAST(MENUMAIN_ID AS TEXT) LIKE '$mainID%'  OR MENUMAIN_ID = 999  " +
            "ORDER BY MENUMAIN_ID ASC ");

    for (var item in maps) {
      MastOutageMenuModel model = MastOutageMenuModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<List<MastOutageMenuModel>> selectChecklist(
      int mainID, int subID) async {
    Database database = await connectedDatabase();
    List<MastOutageMenuModel> models = [];
    //List<Map<String, dynamic>> maps = await database.query('WORKLIST',orderBy: 'REQNO');
    List<Map<String, dynamic>> maps = await database.rawQuery("SELECT * " +
        "FROM  LISTMENU  " +
        "WHERE MENUMAIN_ID = $mainID  AND MENUSUB_ID = $subID  " +
        "ORDER BY MENUCHECKLIST_ID ASC ");

    for (var item in maps) {
      MastOutageMenuModel model = MastOutageMenuModel.fromMap(item);
      models.add(model);
      print("selectChecklist()  model return : " + models.length.toString());
    }

    return models;
  }

  Future<Null> deleteAllList() async {
    Database database = await connectedDatabase();
    try {
      await database.delete('LISTMENU');
      print('====> delete LISTMENU success');
    } catch (e) {}
  }

  ////////----------- LABELS
  Future<Null> insertLabels(MastLabelsModel model) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        'LABELS',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('######## insert MastLabelsModel  success');
    } catch (e) {
      print('insert error : ' + e);
    }
  } //insert

  Future<List<MastLabelsModel>> selectLables(String seq) async {
    Database database = await connectedDatabase();
    List<MastLabelsModel> models = [];
    //List<Map<String, dynamic>> maps = await database.query('WORKLIST',orderBy: 'REQNO');
    List<Map<String, dynamic>> maps = await database.rawQuery("SELECT * " +
        "FROM  LABELS  " +
        "WHERE Seq = '" +
        seq +
        "'  " +
        "ORDER BY Seq ASC ");

    for (var item in maps) {
      MastLabelsModel model = MastLabelsModel.fromMap(item);
      models.add(model);
    }

    return models;
  } //insert

} //class
