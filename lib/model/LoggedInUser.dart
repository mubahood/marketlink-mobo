import 'package:sqflite/sqflite.dart';

import 'Utils.dart';

class LoggedInUser {
  static String tableName = "logged_in_user";

  int id = 0;
  String username = "";
  String password = "";
  String name = "";
  String avatar = "";
  String remember_token = "";
  String created_at = "";
  String updated_at = "";
  String company_id = "";
  String first_name = "";
  String last_name = "";
  String phone_number = "";
  String phone_number_2 = "";
  String address = "";
  String sex = "";
  String dob = "";
  String status = "";
  String email = "";


  static Future<LoggedInUser> getUser() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return LoggedInUser();
    }
    await initTable(db);
    List<Map> maps = await db.query(tableName);
    if (maps.isEmpty) {
      return LoggedInUser();
    }
    return fromJson(maps[0]);
  }

  Future<String> save() async {
    Database db = await Utils.getDb();
    String table_results = await initTable(db);
    if (table_results.isNotEmpty) {
      return table_results;
    }
    await deleteAll();
    try {
      await db.insert(tableName, toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return "";
    } catch (e) {
      return 'Failed to save user because ${e.toString()}.';
    }
    return "";
  }

  static Future<void> deleteAll() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return;
    }
    try {
      await Utils.getDb();
      await db.delete(tableName);
      Utils.toast("Logged out successfully.");
    } catch (e) {
      print(e);
    }
  }

  static Future<String> initTable(Database db) async {
    if (!db.isOpen) {
      return 'Failed to open database.';
    }
    String sql = 'CREATE TABLE IF NOT EXISTS ${tableName} ('
        'id INTEGER PRIMARY KEY'
        ',username TEXT'
        ',password TEXT'
        ',name TEXT'
        ',avatar TEXT'
        ',remember_token TEXT'
        ',created_at TEXT'
        ',updated_at TEXT'
        ',company_id TEXT'
        ',first_name TEXT'
        ',last_name TEXT'
        ',phone_number TEXT'
        ',phone_number_2 TEXT'
        ',address TEXT'
        ',sex TEXT'
        ',dob TEXT'
        ',status TEXT'
        ',email TEXT'
        ')';
    try {
      await db.execute(sql);
      return "";
    } catch (e) {
      return 'Failed to create table because ${e.toString()}.';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'avatar': avatar,
      'remember_token': remember_token,
      'created_at': created_at,
      'updated_at': updated_at,
      'company_id': company_id,
      'first_name': first_name,
      'last_name': last_name,
      'phone_number': phone_number,
      'phone_number_2': phone_number_2,
      'address': address,
      'sex': sex,
      'dob': dob,
      'status': status,
      'email': email,
    };
  }

  static LoggedInUser fromJson(data) {
    if (data == null) {
      return LoggedInUser();
    }
    if (data.runtimeType.toString().contains('map')) {
      return LoggedInUser();
    }

    LoggedInUser obj = LoggedInUser();
    obj.id = int.parse(data['id'].toString());
    obj.username = data['username'].toString();
    obj.password = data['password'].toString();
    obj.name = data['name'].toString();
    obj.avatar = data['avatar'].toString();
    obj.remember_token = data['remember_token'].toString();
    obj.created_at = data['created_at'].toString();
    obj.updated_at = data['updated_at'].toString();
    obj.company_id = data['company_id'].toString();
    obj.first_name = data['first_name'].toString();
    obj.last_name = data['last_name'].toString();
    obj.phone_number = data['phone_number'].toString();
    obj.phone_number_2 = data['phone_number_2'].toString();
    obj.address = data['address'].toString();
    obj.sex = data['sex'].toString();
    obj.dob = data['dob'].toString();
    obj.status = data['status'].toString();
    obj.email = data['email'].toString();

    return obj;
  }
}
