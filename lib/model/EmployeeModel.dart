import 'package:flutter/material.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/model/Utils.dart';
import 'package:sqflite/sqflite.dart';

class EmployeeModel {
  static String end_point = "User";
  static String tableName = "admin_users";

  int id = 0;
  String username = "";
  String password = "";
  String name = "";
  String avatar = "";
  String remember_token = "";
  String created_at = "";
  String updated_at = "";
  String company_id = "";
  String company_text = "";
  String first_name = "";
  String last_name = "";
  String phone_number = "";
  String phone_number_2 = "";
  String address = "";
  String sex = "";
  String dob = "";
  String status = "";
  String email = "";

  static Future<List<EmployeeModel>> get_items({String where = ""}) async {
    List<EmployeeModel> items = await get_local_items();
    if (items.isEmpty) {
      await get_online_items();
      items = await get_local_items();
    } else {
      get_online_items();
    }
    return items;
  }

  static Future<List<EmployeeModel>> get_local_items({
    String where = " 1 ",
  }) async {
    List<EmployeeModel> data = [];
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast('Failed to open database.', c: Colors.red);
      return data;
    }

    String table_resp = await initTable(db);
    if (!table_resp.isEmpty) {
      Utils.toast('Failed to init table admin_users. $table_resp',
          c: Colors.red);
      return data;
    }

    List<Map> maps =
        await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(EmployeeModel.fromJson(maps[i]));
    });
    return data;
  }

  static fromJson(dynamic m) {
    EmployeeModel item = EmployeeModel();
    if (m == null) {
      return item;
    }
    item.id = Utils.int_parse(m['id']);
    item.username = Utils.to_str(m['username']);
    item.password = Utils.to_str(m['password']);
    item.name = Utils.to_str(m['name']);
    item.avatar = Utils.to_str(m['avatar']);
    item.remember_token = Utils.to_str(m['remember_token']);
    item.created_at = Utils.to_str(m['created_at']);
    item.updated_at = Utils.to_str(m['updated_at']);
    item.company_id = Utils.to_str(m['company_id']);
    item.company_text = Utils.to_str(m['company_text']);
    item.first_name = Utils.to_str(m['first_name']);
    item.last_name = Utils.to_str(m['last_name']);
    item.phone_number = Utils.to_str(m['phone_number']);
    item.phone_number_2 = Utils.to_str(m['phone_number_2']);
    item.address = Utils.to_str(m['address']);
    item.sex = Utils.to_str(m['sex']);
    item.dob = Utils.to_str(m['dob']);
    item.status = Utils.to_str(m['status']);
    item.email = Utils.to_str(m['email']);

    return item;
  }

  static Future<void> get_online_items() async {
    if (!(await Utils.isConnected())) {
      return;
    }
    ResponseModel? resp = null;
    try {
      resp = ResponseModel(await Utils.http_get('api/$end_point', {}));
    } catch (e) {
      resp = null;
    }
    if (resp == null) {
      print("FAILED TO FETCH DATA");
      return;
    }

    if (resp.code != 1) {
      Utils.toast(
        "Failed to fetch $tableName data. ${resp.message}",
        c: Colors.red,
      );
      return;
    }

    try {
      await delete_all();
    } catch (e) {
      Utils.toast("Failed to delete all $tableName data. ${e.toString()}",
          c: Colors.red);
    }

    if (!(resp.data.runtimeType.toString().toLowerCase().contains('list'))) {
      Utils.toast("Failed to fetch $tableName data. ${resp.data}",
          c: Colors.red);
      return;
    }

    //database db
    Database db = await Utils.getDb();
    //init table
    String tamp_resp = await initTable(db);

    if (!tamp_resp.isEmpty) {
      Utils.toast("Failed to init table $tableName. $tamp_resp", c: Colors.red);
      return;
    }
    await db.transaction((transaction) async {
      var batch = transaction.batch();
      for (var x in resp?.data) {
        EmployeeModel item = EmployeeModel.fromJson(x);
        try {
          batch.insert(tableName, item.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        } catch (e) {
          Utils.toast("Failed to save $tableName data. ${e.toString()}",
              c: Colors.red);
        }
      }
      try {
        await batch.commit(continueOnError: true);
      } catch (e) {
        Utils.toast("Failed to commit $tableName data. ${e.toString()}",
            c: Colors.red);
      }
    });
  }

  static Future<String> delete_all() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return 'Failed to open database.';
    }
    try {
      await db.delete(tableName);
      return '';
    } catch (e) {
      return 'Failed to delete table because ${e.toString()}.';
    }
  }

  Future<String> delete() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return 'Failed to open database.';
    }
    try {
      await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
      return '';
    } catch (e) {
      return 'Failed to delete item because ${e.toString()}.';
    }
  }

  static Future<String> delete_item(int id) async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return 'Failed to open database.';
    }
    try {
      await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
      return '';
    } catch (e) {
      return 'Failed to delete item because ${e.toString()}.';
    }
  }

  Future<String> save() async {
    Database db = await Utils.getDb();
    String table_results = await initTable(db);
    if (table_results.isNotEmpty) {
      return table_results;
    }
    try {
      await db.insert(tableName, toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return "";
    } catch (e) {
      return 'Failed to save item because ${e.toString()}.';
    }
    return "";
  }

  static Future<String> initTable(Database db) async {
    if (!db.isOpen) {
      Utils.toast('Failed to open database.', c: Colors.red);
      return 'Failed to open database.';
    }
    String sql = 'CREATE TABLE IF NOT EXISTS ${tableName} ('
        "id INTEGER PRIMARY KEY"
        ",username TEXT"
        ",password TEXT"
        ",name TEXT"
        ",avatar TEXT"
        ",remember_token TEXT"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",company_id TEXT"
        ",company_text TEXT"
        ",first_name TEXT"
        ",last_name TEXT"
        ",phone_number TEXT"
        ",phone_number_2 TEXT"
        ",address TEXT"
        ",sex TEXT"
        ",dob TEXT"
        ",status TEXT"
        ",email TEXT"
        ')';
    try {
      await db.execute(sql);
      return "";
    } catch (e) {
      return 'Failed to create table because ${e.toString()}.';
    }
  }

  toJson() {
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
      'company_text': company_text,
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
}
