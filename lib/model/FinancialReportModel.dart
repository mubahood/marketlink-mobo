import 'package:flutter/material.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/model/Utils.dart';
import 'package:sqflite/sqflite.dart';

class FinancialReportModel {
  static String end_point = "FinancialReport";
  static String tableName = "financial_reports";

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String company_id = "";
  String company_text = "";
  String user_id = "";
  String user_text = "";
  String type = "";
  String period_type = "";
  String start_date = "";
  String end_date = "";
  String currency = "";
  String file_generated = "";
  String file = "";
  String total_income = "";
  String total_expense = "";
  String profit = "";
  String include_finance_accounts = "";
  String include_finance_records = "";
  String inventory_total_buying_price = "";
  String inventory_total_selling_price = "";
  String inventory_total_expected_profit = "";
  String inventory_total_earned_profit = "";
  String inventory_include_categories = "";
  String inventory_include_sub_categories = "";
  String inventory_include_products = "";
  String do_generate = "";

  String get_url() {
    String p = '${Utils.API_URL.replaceAll('/api', '')}storage/$file';
    print('======> $p <======');
    return p;
  }

  static Future<List<FinancialReportModel>> get_items(
      {String where = ""}) async {
    List<FinancialReportModel> items = await get_local_items();
    if (items.isEmpty) {
      await get_online_items();
      items = await get_local_items();
    } else {
      get_online_items();
    }
    return items;
  }

  static Future<List<FinancialReportModel>> get_local_items({
    String where = " 1 ",
  }) async {
    List<FinancialReportModel> data = [];
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast('Failed to open database.', c: Colors.red);
      return data;
    }

    String table_resp = await initTable(db);
    if (!table_resp.isEmpty) {
      Utils.toast('Failed to init table financial_reports. $table_resp',
          c: Colors.red);
      return data;
    }

    List<Map> maps =
        await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(FinancialReportModel.fromJson(maps[i]));
    });
    return data;
  }

  static fromJson(dynamic m) {
    FinancialReportModel item = FinancialReportModel();
    if (m == null) {
      return item;
    }
    item.id = Utils.int_parse(m['id']);
    item.created_at = Utils.to_str(m['created_at']);
    item.updated_at = Utils.to_str(m['updated_at']);
    item.company_id = Utils.to_str(m['company_id']);
    item.company_text = Utils.to_str(m['company_text']);
    item.user_id = Utils.to_str(m['user_id']);
    item.user_text = Utils.to_str(m['user_text']);
    item.type = Utils.to_str(m['type']);
    item.period_type = Utils.to_str(m['period_type']);
    item.start_date = Utils.to_str(m['start_date']);
    item.end_date = Utils.to_str(m['end_date']);
    item.currency = Utils.to_str(m['currency']);
    item.file_generated = Utils.to_str(m['file_generated']);
    item.file = Utils.to_str(m['file']);
    item.total_income = Utils.to_str(m['total_income']);
    item.total_expense = Utils.to_str(m['total_expense']);
    item.profit = Utils.to_str(m['profit']);
    item.include_finance_accounts = Utils.to_str(m['include_finance_accounts']);
    item.include_finance_records = Utils.to_str(m['include_finance_records']);
    item.inventory_total_buying_price =
        Utils.to_str(m['inventory_total_buying_price']);
    item.inventory_total_selling_price =
        Utils.to_str(m['inventory_total_selling_price']);
    item.inventory_total_expected_profit =
        Utils.to_str(m['inventory_total_expected_profit']);
    item.inventory_total_earned_profit =
        Utils.to_str(m['inventory_total_earned_profit']);
    item.inventory_include_categories =
        Utils.to_str(m['inventory_include_categories']);
    item.inventory_include_sub_categories =
        Utils.to_str(m['inventory_include_sub_categories']);
    item.inventory_include_products =
        Utils.to_str(m['inventory_include_products']);
    item.do_generate = Utils.to_str(m['do_generate']);

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
        FinancialReportModel item = FinancialReportModel.fromJson(x);
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
        ",user_id TEXT"
        ",user_text TEXT"
        ",type TEXT"
        ",period_type TEXT"
        ",start_date TEXT"
        ",end_date TEXT"
        ",currency TEXT"
        ",file_generated TEXT"
        ",file TEXT"
        ",total_income TEXT"
        ",total_expense TEXT"
        ",profit TEXT"
        ",include_finance_accounts TEXT"
        ",include_finance_records TEXT"
        ",inventory_total_buying_price TEXT"
        ",inventory_total_selling_price TEXT"
        ",inventory_total_expected_profit TEXT"
        ",inventory_total_earned_profit TEXT"
        ",inventory_include_categories TEXT"
        ",inventory_include_sub_categories TEXT"
        ",inventory_include_products TEXT"
        ",do_generate TEXT"
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
      'user_id': user_id,
      'user_text': user_text,
      'type': type,
      'period_type': period_type,
      'start_date': start_date,
      'end_date': end_date,
      'currency': currency,
      'file_generated': file_generated,
      'file': file,
      'total_income': total_income,
      'total_expense': total_expense,
      'profit': profit,
      'include_finance_accounts': include_finance_accounts,
      'include_finance_records': include_finance_records,
      'inventory_total_buying_price': inventory_total_buying_price,
      'inventory_total_selling_price': inventory_total_selling_price,
      'inventory_total_expected_profit': inventory_total_expected_profit,
      'inventory_total_earned_profit': inventory_total_earned_profit,
      'inventory_include_categories': inventory_include_categories,
      'inventory_include_sub_categories': inventory_include_sub_categories,
      'inventory_include_products': inventory_include_products,
      'do_generate': do_generate,
    };
  }
}
