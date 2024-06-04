import 'package:flutter/material.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/model/Utils.dart';
import 'package:sqflite/sqflite.dart';

class FinancialCategory {
  static String end_point = "FinancialCategory";
  static String tableName = "financial_categories";

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String company_id = "";
  String company_text = "";
  String total_income = "";
  String total_expense = "";
  String name = "";
  String description = "";

  static Future<List<FinancialCategory>> get_items({String where = ""}) async {
    List<FinancialCategory> items = await get_local_items();
    if (items.isEmpty) {
      await get_online_items();
      items = await get_local_items();
    } else {
      get_online_items();
    }
    return items;
  }

  static Future<List<FinancialCategory>> get_local_items({
    String where = " 1 ",
  }) async {
    List<FinancialCategory> data = [];
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast('Failed to open database.', c: Colors.red);
      return data;
    }

    String table_resp = await initTable(db);
    if (!table_resp.isEmpty) {
      Utils.toast('Failed to init table financial_categories. $table_resp',
          c: Colors.red);
      return data;
    }

    List<Map> maps =
        await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(FinancialCategory.fromJson(maps[i]));
    });
    return data;
  }

  static fromJson(dynamic m) {
    FinancialCategory item = FinancialCategory();
    if (m == null) {
      return item;
    }
    item.id = Utils.int_parse(m['id']);
    item.created_at = Utils.to_str(m['created_at']);
    item.updated_at = Utils.to_str(m['updated_at']);
    item.company_id = Utils.to_str(m['company_id']);
    item.company_text = Utils.to_str(m['company_text']);
    item.total_income = Utils.to_str(m['total_income']);
    item.total_expense = Utils.to_str(m['total_expense']);
    item.name = Utils.to_str(m['name']);
    item.description = Utils.to_str(m['description']);

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
        FinancialCategory item = FinancialCategory.fromJson(x);
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
        ",created_at TEXT"
        ",updated_at TEXT"
        ",company_id TEXT"
        ",company_text TEXT"
        ",total_income TEXT"
        ",total_expense TEXT"
        ",name TEXT"
        ",description TEXT"
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
      'created_at': created_at,
      'updated_at': updated_at,
      'company_id': company_id,
      'company_text': company_text,
      'total_income': total_income,
      'total_expense': total_expense,
      'name': name,
      'description': description,
    };
  }
}
