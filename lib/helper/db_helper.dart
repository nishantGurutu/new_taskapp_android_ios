import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/model/lead_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';

// class DbHelper {
//   static final DbHelper _instance = DbHelper._internal();
//   factory DbHelper() => _instance;

//   DbHelper._internal();

//   Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     String databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, 'task_database.db');

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         // Create leads table
//         await db.execute('''
//         CREATE TABLE leads (
//           id INTEGER PRIMARY KEY,
//           lead_number TEXT,
//           user_id INTEGER,
//           lead_name TEXT,
//           lead_type TEXT,
//           company TEXT,
//           phone TEXT,
//           email TEXT,
//           source INTEGER,
//           designation TEXT,
//           gender TEXT,
//           status INTEGER,
//           no_of_project TEXT,
//           description TEXT,
//           regional_ofc TEXT,
//           reference_details TEXT,
//           image TEXT,
//           type TEXT,
//           address_type TEXT,
//           address_line1 TEXT,
//           address_line2 TEXT,
//           city_town TEXT,
//           postal_code TEXT,
//           sector_locality TEXT,
//           country TEXT,
//           state TEXT,
//           visiting_card TEXT,
//           latitude TEXT,
//           longitude TEXT,
//           is_deleted INTEGER,
//           created_at TEXT,
//           updated_at TEXT,
//           source_name TEXT,
//           status_name TEXT,
//           owner_name TEXT
//         )
//       ''');

//         await db.execute('''
//           CREATE TABLE responsiblePerson (
//             id INTEGER PRIMARY KEY,
//             employee_id TEXT,
//             name TEXT,
//             email TEXT,
//             department_id INTEGER,
//             company_id INTEGER,
//             shift_id INTEGER,
//             checkin_type INTEGER,
//             attendance_type INTEGER,
//             role INTEGER,
//             phone TEXT,
//             phone2 TEXT,
//             image TEXT,
//             gender TEXT,
//             dob TEXT,
//             email_verified_at TEXT,
//             recovery_password TEXT,
//             location TEXT,
//             fcm_token TEXT,
//             status INTEGER,
//             type INTEGER,
//             anniversary_date TEXT,
//             anniversary_type TEXT,
//             branding_image TEXT,
//             is_logged_in INTEGER,
//             marital_status TEXT,
//             blood_group TEXT,
//             father_name TEXT,
//             mother_name TEXT,
//             spouse_name TEXT,
//             physically_challenged TEXT,
//             location2 TEXT,
//             city TEXT,
//             state TEXT,
//             pincode TEXT,
//             salary_cycle TEXT,
//             reporting_manager TEXT,
//             staff_type TEXT,
//             date_of_joining TEXT,
//             uan TEXT,
//             panno TEXT,
//             adharno TEXT,
//             adhar_enrollmentno TEXT,
//             pf_no TEXT,
//             pf_joining_date TEXT,
//             pf_eligible TEXT,
//             esi_eligible TEXT,
//             esi_no TEXT,
//             pt_eligible TEXT,
//             lwf_eligible TEXT,
//             eps_eligible TEXT,
//             eps_joining_date TEXT,
//             eps_exit_date TEXT,
//             hps_eligible TEXT,
//             name_of_bank TEXT,
//             ifsc_code TEXT,
//             account_no TEXT,
//             name_of_account_holder TEXT,
//             upi_details TEXT,
//             weekoff TEXT,
//             device_id TEXT,
//             is_head INTEGER,
//             assigned_dept TEXT,
//             platform TEXT,
//             app_version TEXT,
//             android_version TEXT,
//             model_name TEXT,
//             google_access_token TEXT,
//             created_at TEXT,
//             updated_at TEXT
//           )
//         ''');
//       },
//     );
//   }

//   Future<void> insertLeads(List<LeadListData> leads) async {
//     final db = await database;
//     Batch batch = db.batch();

//     for (var lead in leads) {
//       batch.insert(
//         'leads',
//         lead.toJson(),
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     }

//     await batch.commit(noResult: true);
//   }

//   Future<List<LeadListData>> getAllLeadsFromDB() async {
//     final db = await database;
//     final List<Map<String, dynamic>> result = await db.query(
//       'leads',
//     );
//     return result
//         .map((json) => LeadListData.fromJson(json))
//         .toList()
//         .reversed
//         .toList();
//   }

//   Future<void> inserResponsiblePerson(List<ResponsiblePersonData> leads) async {
//     final db = await database;
//     Batch batch = db.batch();

//     for (var lead in leads) {
//       batch.insert(
//         'responsiblePerson',
//         lead.toJson(),
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     }

//     await batch.commit(noResult: true);
//     final count = Sqflite.firstIntValue(
//       await db.rawQuery('SELECT COUNT(*) FROM responsiblePerson'),
//     );

//     print("📥 Total inserted into responsiblePerson table: $count");
//   }

//   Future<void> insertAreaList(List<ResponsiblePersonData> leads) async {
//     final Database db = await instance.database;
//     print('area list count length ${bannerDataList.first.count}');
//     for (var bannerData in bannerDataList) {
//       await db.insert(
//         'area',
//         bannerData.toJson(),
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     }
//   }

//   Future<List<ResponsiblePersonData>> getResponsiblePersondata() async {
//     final db = await database;
//     final List<Map<String, dynamic>> result =
//         await db.query('responsiblePerson');

//     print("📦 Raw rows in responsiblePerson: ${result.length}");
//     if (result.isNotEmpty) print("🔍 Sample row: ${result.first}");

//     return result
//         .map((json) => ResponsiblePersonData.fromJson(json))
//         .toList()
//         .reversed
//         .toList();
//   }
// }

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'taskManagement.db');

    return await openDatabase(path,
        version: 3, onCreate: _createDb, onUpgrade: _onUpgrade);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE area ADD COLUMN count INTEGER');
    }
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS responsiblePerson');

    await db.execute('''
          CREATE TABLE responsiblePerson (
            id INTEGER PRIMARY KEY,
            employee_id TEXT,
            name TEXT,
            email TEXT,
            department_id INTEGER,
            company_id INTEGER,
            shift_id INTEGER,
            checkin_type INTEGER,
            attendance_type INTEGER,
            role INTEGER,
            phone TEXT,
            phone2 TEXT,
            image TEXT,
            gender TEXT,
            dob TEXT,
            email_verified_at TEXT,
            recovery_password TEXT,
            location TEXT,
            fcm_token TEXT,
            status INTEGER,
            type INTEGER,
            anniversary_date TEXT,
            anniversary_type TEXT,
            branding_image TEXT,
            is_logged_in INTEGER,
            marital_status TEXT,
            blood_group TEXT,
            father_name TEXT,
            mother_name TEXT,
            spouse_name TEXT,
            physically_challenged TEXT,
            location2 TEXT,
            city TEXT,
            state TEXT,
            pincode TEXT,
            salary_cycle TEXT,
            reporting_manager TEXT,
            staff_type TEXT,
            date_of_joining TEXT,
            uan TEXT,
            panno TEXT,
            adharno TEXT,
            adhar_enrollmentno TEXT,
            pf_no TEXT,
            pf_joining_date TEXT,
            pf_eligible TEXT,
            esi_eligible TEXT,
            esi_no TEXT,
            pt_eligible TEXT,
            lwf_eligible TEXT,
            eps_eligible TEXT,
            eps_joining_date TEXT,
            eps_exit_date TEXT,
            hps_eligible TEXT,
            name_of_bank TEXT,
            ifsc_code TEXT,
            account_no TEXT,
            name_of_account_holder TEXT,
            upi_details TEXT,
            weekoff TEXT,
            device_id TEXT,
            is_head INTEGER,
            assigned_dept TEXT,
            platform TEXT,
            app_version TEXT,
            android_version TEXT,
            model_name TEXT,
            google_access_token TEXT,
            created_at TEXT,
            updated_at TEXT
          )
        ''');
  }
}
