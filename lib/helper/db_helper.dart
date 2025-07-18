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
        version: 5, onCreate: _createDb, onUpgrade: _onUpgrade);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE leads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lead_name TEXT,
        company_name TEXT,
        phone TEXT,
        email TEXT,
        source TEXT,
        industry TEXT,
        status TEXT,
        tag TEXT,
        description TEXT,
        address TEXT,
        latitude REAL,
        longitude REAL,
        image_path TEXT,
        audio_path TEXT,
        timestamp TEXT
      )
      ''');
    }
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS responsiblePerson');
    await db.execute('DROP TABLE IF EXISTS locations');
    await db.execute('DROP TABLE IF EXISTS leads');

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

    await db.execute('''
      CREATE TABLE leads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lead_name TEXT,
        company_name TEXT,
        phone TEXT,
        email TEXT,
        source TEXT,
        industry TEXT,
        status TEXT,
        tag TEXT,
        description TEXT,
        address TEXT,
        latitude REAL,
        longitude REAL,
        image_path TEXT,
        audio_path TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<void> insertLead({
    required String leadName,
    required String companyName,
    required String phone,
    required String email,
    required String source,
    required String industry,
    required String status,
    required String tag,
    required String description,
    required String address,
    required String imagePath,
    required String audioPath,
    required double? latitude,
    required double? longitude,
    required String timestamp,
  }) async {
    final db = await database;

    // Print input data for debugging
    print('Inserting lead with the following data:');
    print('Lead Name: $leadName');
    print('Company Name: $companyName');
    print('Phone: $phone');
    print('Email: $email');
    print('Source: $source');
    print('Industry: $industry');
    print('Status: $status');
    print('Tag: $tag');
    print('Description: $description');
    print('Address: $address');
    print('Image Path: $imagePath');
    print('Audio Path: $audioPath');
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    print('Timestamp: $timestamp');

    // Insert the lead data
    await db.insert(
      'leads',
      {
        'lead_name': leadName,
        'company_name': companyName,
        'phone': phone,
        'email': email,
        'source': source,
        'industry': industry,
        'status': status,
        'tag': tag,
        'description': description,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'image_path': imagePath,
        'audio_path': audioPath,
        'timestamp': timestamp,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Verify insertion by querying the newly inserted lead
    final insertedLeads = await db.query(
      'leads',
      where: 'timestamp = ?',
      whereArgs: [timestamp],
    );

    if (insertedLeads.isNotEmpty) {
      print('Lead successfully inserted:');
      print(insertedLeads.first);
    } else {
      print('Failed to find the inserted lead in the database.');
    }
  }

  // Method to get all leads
  Future<List<Map<String, dynamic>>> getLeads() async {
    final db = await database;
    return await db.query('leads', orderBy: 'timestamp DESC');
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
