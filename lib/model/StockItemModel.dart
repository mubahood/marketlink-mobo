import 'package:flutter/material.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/model/Utils.dart';
import 'package:sqflite/sqflite.dart';

class StockItemModel {
  static String end_point = "StockItem";
  static String tableName = "stock_items";

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String company_id = "";
  String company_text = "";
  String created_by_id = "";
  String created_by_text = "";
  String stock_category_id = "";
  String stock_category_text = "";
  String stock_sub_category_id = "";
  String stock_sub_category_text = "";
  String financial_period_id = "";
  String financial_period_text = "";
  String name = "";
  String description = "";
  String image = "";
  String barcode = "";
  String sku = "";
  String generate_sku = "";
  String update_sku = "";
  String gallery = "";
  String buying_price = "";
  String selling_price = "";
  String original_quantity = "";
  String current_quantity = "";

  double get_progress() {
    if (Utils.int_parse(this.original_quantity) < 0) {
      return 0;
    }
    return Utils.int_parse(this.current_quantity) /
        Utils.int_parse(this.original_quantity);
  }

  static Future<List<StockItemModel>> get_items({String where = ""}) async {
    List<StockItemModel> items = await get_local_items(
      where: where,
    );
    if (items.isEmpty) {
      await get_online_items();
      items = await get_local_items(
        where: where,
      );
    } else {
      get_online_items();
    }
    return items;
  }

  static Future<List<StockItemModel>> get_local_items({
    String where = " 1 ",
  }) async {
    List<StockItemModel> data = [];
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast('Failed to open database.', c: Colors.red);
      return data;
    }

    String table_resp = await initTable(db);
    if (!table_resp.isEmpty) {
      Utils.toast('Failed to init table stock_items. $table_resp',
          c: Colors.red);
      return data;
    }

    if (where.isEmpty) {
      where = " 1 ";
    }

    List<Map> maps =
    await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(StockItemModel.fromJson(maps[i]));
    });
    return data;
  }

  static fromJson(dynamic m) {
    StockItemModel item = StockItemModel();
    if (m == null) {
      return item;
    }
    item.id = Utils.int_parse(m['id']);
    item.created_at = Utils.to_str(m['created_at']);
    item.updated_at = Utils.to_str(m['updated_at']);
    item.company_id = Utils.to_str(m['company_id']);
    item.company_text = Utils.to_str(m['company_text']);
    item.created_by_id = Utils.to_str(m['created_by_id']);
    item.created_by_text = Utils.to_str(m['created_by_text']);
    item.stock_category_id = Utils.to_str(m['stock_category_id']);
    item.stock_category_text = Utils.to_str(m['stock_category_text']);
    item.stock_sub_category_id = Utils.to_str(m['stock_sub_category_id']);
    item.stock_sub_category_text = Utils.to_str(m['stock_sub_category_text']);
    item.financial_period_id = Utils.to_str(m['financial_period_id']);
    item.financial_period_text = Utils.to_str(m['financial_period_text']);
    item.name = Utils.to_str(m['name']);
    item.description = Utils.to_str(m['description']);
    item.image = Utils.to_str(m['image']);
    item.barcode = Utils.to_str(m['barcode']);
    item.sku = Utils.to_str(m['sku']);
    item.generate_sku = Utils.to_str(m['generate_sku']);
    item.update_sku = Utils.to_str(m['update_sku']);
    item.gallery = Utils.to_str(m['gallery']);
    item.buying_price = Utils.to_str(m['buying_price']);
    item.selling_price = Utils.to_str(m['selling_price']);
    item.original_quantity = Utils.to_str(m['original_quantity']);
    item.current_quantity = Utils.to_str(m['current_quantity']);

    return item;
  }

  static Future<void> get_online_items() async {
    if (!(await Utils.isConnected())) {
      return;
    }
    ResponseModel? resp = null;
    try {
      print("=fetching data from server=");
      resp = ResponseModel(await Utils.http_get('api/$end_point', {}));
      print("===SUCCESS===");
      print(resp.data);
      print(resp.message);
    } catch (e) {
      print("------FAILED TO FETCH DATA------");
      print(e);
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
        StockItemModel item = StockItemModel.fromJson(x);
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
        ",created_by_id TEXT"
        ",created_by_text TEXT"
        ",stock_category_id TEXT"
        ",stock_category_text TEXT"
        ",stock_sub_category_id TEXT"
        ",stock_sub_category_text TEXT"
        ",financial_period_id TEXT"
        ",financial_period_text TEXT"
        ",name TEXT"
        ",description TEXT"
        ",image TEXT"
        ",barcode TEXT"
        ",sku TEXT"
        ",generate_sku TEXT"
        ",update_sku TEXT"
        ",gallery TEXT"
        ",buying_price TEXT"
        ",selling_price TEXT"
        ",original_quantity TEXT"
        ",current_quantity TEXT"
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
      'created_by_id': created_by_id,
      'created_by_text': created_by_text,
      'stock_category_id': stock_category_id,
      'stock_category_text': stock_category_text,
      'stock_sub_category_id': stock_sub_category_id,
      'stock_sub_category_text': stock_sub_category_text,
      'financial_period_id': financial_period_id,
      'financial_period_text': financial_period_text,
      'name': name,
      'description': description,
      'image': image,
      'barcode': barcode,
      'sku': sku,
      'generate_sku': generate_sku,
      'update_sku': update_sku,
      'gallery': gallery,
      'buying_price': buying_price,
      'selling_price': selling_price,
      'original_quantity': original_quantity,
      'current_quantity': current_quantity,
    };
  }
}
