import 'package:flutter/material.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/model/Utils.dart';
import 'package:sqflite/sqflite.dart';

class BudgetItemModel {
  static String end_point = "BudgetItem";
  static String tableName = "budget_items";

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String budget_program_id = "";
  String budget_program_text = "";
  String budget_item_category_id = "";
  String budget_item_category_text = "";
  String company_id = "";
  String company_text = "";
  String created_by_id = "";
  String created_by_text = "";
  String changed_by_id = "";
  String changed_by_text = "";
  String name = "";
  String target_amount = "";
  String invested_amount = "";
  String balance = "";
  String percentage_done = "";
  String is_complete = "";
  String unit_price = "";
  String quantity = "";
  String approved = "";
  String details = "";
  bool exp = false;

  static Future<List<BudgetItemModel>> get_items({String where = ""}) async {
    List<BudgetItemModel> items = await get_local_items();
    if (items.isEmpty) {
      await get_online_items();
      items = await get_local_items();
    } else {
      get_online_items();
    }
    return items;
  }

  static Future<List<BudgetItemModel>> get_local_items({
    String where = " 1 ",
  }) async {
    List<BudgetItemModel> data = [];
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast('Failed to open database.', c: Colors.red);
      return data;
    }

    String table_resp = await initTable(db);
    if (!table_resp.isEmpty) {
      Utils.toast('Failed to init table budget_items. $table_resp',
          c: Colors.red);
      return data;
    }

    List<Map> maps =
        await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(BudgetItemModel.fromJson(maps[i]));
    });
    return data;
  }

  static fromJson(dynamic m) {
    BudgetItemModel item = BudgetItemModel();
    if (m == null) {
      return item;
    }
    item.id = Utils.int_parse(m['id']);
    item.created_at = Utils.to_str(m['created_at']);
    item.updated_at = Utils.to_str(m['updated_at']);
    item.budget_program_id = Utils.to_str(m['budget_program_id']);
    item.budget_program_text = Utils.to_str(m['budget_program_text']);
    item.budget_item_category_id = Utils.to_str(m['budget_item_category_id']);
    item.budget_item_category_text =
        Utils.to_str(m['budget_item_category_text']);
    item.company_id = Utils.to_str(m['company_id']);
    item.company_text = Utils.to_str(m['company_text']);
    item.created_by_id = Utils.to_str(m['created_by_id']);
    item.created_by_text = Utils.to_str(m['created_by_text']);
    item.changed_by_id = Utils.to_str(m['changed_by_id']);
    item.changed_by_text = Utils.to_str(m['changed_by_text']);
    item.name = Utils.to_str(m['name']);
    item.target_amount = Utils.to_str(m['target_amount']);
    item.invested_amount = Utils.to_str(m['invested_amount']);
    item.balance = Utils.to_str(m['balance']);
    item.percentage_done = Utils.to_str(m['percentage_done']);
    item.is_complete = Utils.to_str(m['is_complete']);
    item.unit_price = Utils.to_str(m['unit_price']);
    item.quantity = Utils.to_str(m['quantity']);
    item.approved = Utils.to_str(m['approved']);
    item.details = Utils.to_str(m['details']);

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
        BudgetItemModel item = BudgetItemModel.fromJson(x);
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
        ",budget_program_id TEXT"
        ",budget_program_text TEXT"
        ",budget_item_category_id TEXT"
        ",budget_item_category_text TEXT"
        ",company_id TEXT"
        ",company_text TEXT"
        ",created_by_id TEXT"
        ",created_by_text TEXT"
        ",changed_by_id TEXT"
        ",changed_by_text TEXT"
        ",name TEXT"
        ",target_amount TEXT"
        ",invested_amount TEXT"
        ",balance TEXT"
        ",percentage_done TEXT"
        ",is_complete TEXT"
        ",unit_price TEXT"
        ",quantity TEXT"
        ",approved TEXT"
        ",details TEXT"
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
      'budget_program_id': budget_program_id,
      'budget_program_text': budget_program_text,
      'budget_item_category_id': budget_item_category_id,
      'budget_item_category_text': budget_item_category_text,
      'company_id': company_id,
      'company_text': company_text,
      'created_by_id': created_by_id,
      'created_by_text': created_by_text,
      'changed_by_id': changed_by_id,
      'changed_by_text': changed_by_text,
      'name': name,
      'target_amount': target_amount,
      'invested_amount': invested_amount,
      'balance': balance,
      'percentage_done': percentage_done,
      'is_complete': is_complete,
      'unit_price': unit_price,
      'quantity': quantity,
      'approved': approved,
      'details': details,
    };
  }
}
