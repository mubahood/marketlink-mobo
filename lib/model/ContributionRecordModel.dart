import 'package:flutter/material.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/model/Utils.dart';
import 'package:sqflite/sqflite.dart';

class ContributionRecordModel {
  static String end_point = "ContributionRecord";
  static String tableName = "contribution_records";

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String budget_program_id = "";
  String budget_program_text = "";
  String company_id = "";
  String company_text = "";
  String treasurer_id = "";
  String treasurer_text = "";
  String chaned_by_id = "";
  String chaned_by_text = "";
  String name = "";
  String amount = "";
  String paid_amount = "";
  String not_paid_amount = "";
  String fully_paid = "";
  String custom_amount = "";
  String custom_paid_amount = "";
  String category_id = "";
  String category_text = "";
  bool exp = false;

  static Future<List<ContributionRecordModel>> get_items(
      {String where = ""}) async {
    if (where.trim().isEmpty) {
      where = " 1 ";
    }

    List<ContributionRecordModel> items = await get_local_items(where: where);
    if (items.isEmpty) {
      await get_online_items();
      items = await get_local_items(where: where);
    } else {
      get_online_items();
    }
    return items;
  }

  static Future<List<ContributionRecordModel>> get_local_items({
    String where = " 1 ",
  }) async {
    List<ContributionRecordModel> data = [];
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast('Failed to open database.', c: Colors.red);
      return data;
    }

    String table_resp = await initTable(db);
    if (!table_resp.isEmpty) {
      Utils.toast('Failed to init table contribution_records. $table_resp',
          c: Colors.red);
      return data;
    }

    List<Map> maps =
        await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(ContributionRecordModel.fromJson(maps[i]));
    });
    return data;
  }

  static fromJson(dynamic m) {
    ContributionRecordModel item = ContributionRecordModel();
    if (m == null) {
      return item;
    }
    item.id = Utils.int_parse(m['id']);
    item.created_at = Utils.to_str(m['created_at']);
    item.updated_at = Utils.to_str(m['updated_at']);
    item.budget_program_id = Utils.to_str(m['budget_program_id']);
    item.budget_program_text = Utils.to_str(m['budget_program_text']);
    item.company_id = Utils.to_str(m['company_id']);
    item.company_text = Utils.to_str(m['company_text']);
    item.treasurer_id = Utils.to_str(m['treasurer_id']);
    item.treasurer_text = Utils.to_str(m['treasurer_text']);
    item.chaned_by_id = Utils.to_str(m['chaned_by_id']);
    item.chaned_by_text = Utils.to_str(m['chaned_by_text']);
    item.name = Utils.to_str(m['name']);
    item.amount = Utils.to_str(m['amount']);
    item.paid_amount = Utils.to_str(m['paid_amount']);
    item.not_paid_amount = Utils.to_str(m['not_paid_amount']);
    item.fully_paid = Utils.to_str(m['fully_paid']);
    item.custom_amount = Utils.to_str(m['custom_amount']);
    item.custom_paid_amount = Utils.to_str(m['custom_paid_amount']);
    item.category_id = Utils.to_str(m['category_id']);
    item.category_text = Utils.to_str(m['category_text']);

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
        ContributionRecordModel item = ContributionRecordModel.fromJson(x);
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
        ",company_id TEXT"
        ",company_text TEXT"
        ",treasurer_id TEXT"
        ",treasurer_text TEXT"
        ",chaned_by_id TEXT"
        ",chaned_by_text TEXT"
        ",name TEXT"
        ",amount TEXT"
        ",paid_amount TEXT"
        ",not_paid_amount TEXT"
        ",fully_paid TEXT"
        ",custom_amount TEXT"
        ",custom_paid_amount TEXT"
        ",category_id TEXT"
        ",category_text TEXT"
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
      'company_id': company_id,
      'company_text': company_text,
      'treasurer_id': treasurer_id,
      'treasurer_text': treasurer_text,
      'chaned_by_id': chaned_by_id,
      'chaned_by_text': chaned_by_text,
      'name': name,
      'amount': amount,
      'paid_amount': paid_amount,
      'not_paid_amount': not_paid_amount,
      'fully_paid': fully_paid,
      'custom_amount': custom_amount,
      'custom_paid_amount': custom_paid_amount,
      'category_id': category_id,
      'category_text': category_text,
    };
  }

  List<String> thanks = [
    'Thank you so much for your contribution.',
    'Thank you so much for your support.',
    'Thank you so much for your support. May God bless you.',
    'Thank you so much for your support. May God reward you.',
    'Thank you so much for your support. May Allah bless you abundantly.',
    'Thank you so much for your support. May Allah reward you abundantly.',
    'Thank you so much for your support. May God bless you abundantly.',
    'Thank you so much for your support. May God reward you abundantly.',
  ];

  /*
  *
  *
  *

UGX 65,000 Cash received from Peter Kwesiga 🙏

May God bless you

🧎

  *
  *
 Cash received from Sulaiman Kabalo UGX 20,000 🙏

Thank you so much for your support. May God reward you.

🧎

  * */

  String getThanks() {
    String msg = " Cash received from " +
        "*" +
        name.trim() +
        "* - " +
        " UGX " +
        Utils.moneyFormat(paid_amount) +
        " 🙏\n"
            "\n";
    thanks.shuffle();
    msg += thanks[3];
    msg += "\n\n🧎";
    return msg;
  }
}
