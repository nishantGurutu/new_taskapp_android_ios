import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
        version: 4, onCreate: _createDb, onUpgrade: _onUpgrade);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE area ADD COLUMN count INTEGER');
    }
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE locations (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          employee_id TEXT,
          latitude REAL,
          longitude REAL,
          timestamp TEXT,
          accuracy REAL,
          altitude REAL,
          speed REAL
        )
      ''');
    }
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS responsiblePerson');
    await db.execute('DROP TABLE IF EXISTS locations');

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

    await db.execute('''
      CREATE TABLE locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_id TEXT,
        latitude REAL,
        longitude REAL,
        timestamp TEXT,
        accuracy REAL,
        altitude REAL,
        speed REAL
      )
    ''');
  }

  // Method to insert a location
  Future<void> insertLocation(
      String employeeId,
      double latitude,
      double longitude,
      String timestamp,
      double accuracy,
      double altitude,
      double speed) async {
    final db = await database;
    await db.insert(
      'locations',
      {
        'employee_id': employeeId,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp,
        'accuracy': accuracy,
        'altitude': altitude,
        'speed': speed,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Method to get location history for a user
  Future<List<Map<String, dynamic>>> getLocationHistory(
      String employeeId) async {
    final db = await database;
    return await db.query(
      'locations',
      where: 'employee_id = ?',
      whereArgs: [employeeId],
      orderBy: 'timestamp DESC',
    );
  }
}
