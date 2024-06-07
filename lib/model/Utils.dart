import 'dart:convert';

import 'package:dio/dio.dart' as dioPackage;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ui/model/LoggedInUser.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static String to_date_1(dynamic updatedAt) {
    String dateText = "__/__/___";
    if (updatedAt == null) {
      return "__/__/____";
    }
    if (updatedAt.toString().length < 5) {
      return "__/__/____";
    }

    try {
      DateTime date = DateTime.parse(updatedAt.toString());

      dateText = DateFormat("d MMM, y").format(date);
    } catch (e) {}

    return dateText;
  }

  static String to_date(dynamic updated_at) {
    String date_text = "--:--";
    if (updated_at == null) {
      return "--:--";
    }
    if (updated_at.toString().length < 5) {
      return "--:--";
    }

    try {
      DateTime date = intl.DateFormat("yyyy-MM-ddTHH:mm:ssZ")
          .parseUTC(updated_at.toString())
          .toLocal();

      date_text = intl.DateFormat("d MMM, y - ").format(date);
      date_text += intl.DateFormat("jm").format(
          date); // convert local date time to string format local date time
      return date_text;
    } catch (e) {}

    return date_text;
  }

  static log(String message) {
    debugPrint(message, wrapWidth: 1200);
  }

  static urlLauncher(
    String url, {
    String title = "Open Link",
    String message = "You are about to open the link in your browser.",
  }) async {
    Get.defaultDialog(
      title: title,
      middleText: message,
      actions: [
        ElevatedButton(
          onPressed: () async {
            Get.back();
            if (!await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            )) {
              throw Exception('Could not launch $url');
            }
          },
          child: Text('Continue'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(100, 50),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Cancel'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(100, 50),
          ),
        ),
      ],
    );
  }

  static String greet() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    if (hour < 21) {
      return 'Good Evening';
    }
    return 'Good Night';
  }

  static int int_parse(dynamic y) {
    if (y == null) {
      return 0;
    }
    String x = y.toString();
    if (x.contains('.')) {
      x = x.split('.')[0];
    }
    int temp = 0;
    try {
      temp = int.parse(x.toString());
    } catch (e) {
      temp = 0;
    }
    return temp;
  }

  static String to_str(dynamic x, {String y = ""}) {
    if (x == null) {
      return y;
    }
    if (x.toString().toString() == 'null') {
      return y;
    }
    if (x.toString().isEmpty) {
      return y.toString();
    }
    if (x is List<String> && x.isNotEmpty) {
      return jsonEncode(x);
    }
    return x.toString();
  }

  static void toast(String message, {Color c = Colors.green}) {
    Get.snackbar(
      "Alert",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: c,
      colorText: Colors.white,
    );
  }

  static Future<bool> is_connected() async {
    return await Utils.isConnected();
  }

  static Future<bool> isConnected() async {
    return await InternetConnectionChecker().hasConnection;
  }

  static Future<dynamic> http_get(
      String endpoint, Map<String, dynamic> data) async {
    if (!(await isConnected())) {
      return {
        'code': 0,
        'message': 'No internet connection.',
        'data': null,
      };
    }

    var resp = null;

    LoggedInUser user = await LoggedInUser.getUser();
    data['company_id'] = user.company_id.toString();
    data['logged_in_user_id'] = user.id.toString();
    data['budget_program_id'] = '1'.toString();

    final dio = Dio();
    try {
      print('${Utils.API_URL}${endpoint}');
      resp = await dio.get(
        '${Utils.API_URL}${endpoint}',
        queryParameters: data,
        options: Options(headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'logged_in_user_id': user.id.toString(),
          'company_id': user.company_id.toString(),
        }),
      );
    } on DioException catch (e) {
      return {'code': 0, 'message': e.message, 'data': null};
    }
    if (resp != null) {
      if (resp.data == null) {
        return {
          'code': 0,
          'message':
              'Sever returned empty response. ${resp.statusMessage}, ${resp.toString()}',
          'data': null
        };
      }
      return resp.data;
    } else {
      return {
        'code': 0,
        'message': 'Failed to connect to server. Response is null.',
        'data': null
      };
    }
  }

  static Future<dynamic> http_post(
      String endpoint, Map<String, dynamic> data) async {
    if (!(await isConnected())) {
      return {
        'code': 0,
        'message': 'No internet connection.',
        'data': null,
      };
    }

    var resp = null;

    LoggedInUser user = await LoggedInUser.getUser();
    data['company_id'] = user.company_id.toString();
    data['chaned_by_id'] = user.id.toString();
    data['logged_in_user_id'] = user.id.toString();
    data['budget_program_id'] = '1'.toString();

    var upload_data = dioPackage.FormData.fromMap(data); //.fromMap();
    final dio = Dio();
    try {
      resp = await dio.post(
        '${Utils.API_URL}${endpoint}',
        data: upload_data,
        options: Options(headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'logged_in_user_id': user.id.toString(),
          'company_id': user.company_id.toString(),
        }),
      );
      print("====success====");
      print(resp.data);
    } on DioException catch (e) {
      print("====error====");
      print(e.toString());
      return {'code': 0, 'message': e.message, 'data': null};
    }
    if (resp != null) {
      if (resp.data == null) {
        return {
          'code': 0,
          'message':
              'Sever returned empty response. ${resp.statusMessage}, ${resp.toString()}',
          'data': null
        };
      }
      return resp.data;
    } else {
      return {
        'code': 0,
        'message': 'Failed to connect to server. Response is null.',
        'data': null
      };
    }
  }

  //from string to DateTime
  static DateTime toDate(String date) {
    if (date.isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(date);
    } catch (e) {
      return DateTime.now();
    }
  }

  // static final String API_URL = "https://invetotrack.ugnews24.info/api/";

  static final String API_URL = "http://10.0.2.2:8888/marketlink-web-main/api/";

  static final int APP_VERSION = 1;
  static final String DATABASE_PATH = "INVETO_TRACK_${APP_VERSION}";
  static final String APP_NAME = "MarketLink";

  static Future<Database> getDb() async {
    return await openDatabase(DATABASE_PATH, version: APP_VERSION);
  }

  static void showLoader(bool dismissable) {
    if (EasyLoading.isShow) {
      return;
    } else {
      EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: dismissable,
      );
    }
  }

  static void hideLoader() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    return;
  }

  static String getImageUrl(String image) {
    print("${API_URL.replaceAll('/api', '')}/storage/$image");
    return "${API_URL.replaceAll('/api', '')}/storage/$image";
  }

  static String formatDate(String created_at) {
    DateTime date = DateTime.parse(created_at);
    return "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}${date.hour > 12 ? 'PM' : 'AM'}";
  }

  static moneyFormat(String amount) {
    // Reverse the string to simplify insertion of commas
    String reversedAmount = amount.split('').reversed.join();

    // Insert commas after every three characters
    String formattedAmount = '';
    for (int i = 0; i < reversedAmount.length; i++) {
      if (i != 0 && i % 3 == 0) {
        formattedAmount += ',';
      }
      formattedAmount += reversedAmount[i];
    }

    // Reverse the formatted string back to its original order
    formattedAmount = formattedAmount.split('').reversed.join();

    return formattedAmount;
  }

  static Color getContextColor(String type) {
    type = type.toLowerCase();
/*
*           'Sale' => 'Sale',
                    'Damage' => 'Damage',
                    'Expired' => 'Expired',
                    'Lost' => 'Lost',
                    'Internal Use' => 'Internal Use',
                    'Other' => 'Other'
* */
    switch (type) {
      case 'sale':
        return Colors.green;
      case 'damage':
        return Colors.red;
      case 'expired':
        return Colors.red;
      case 'lost':
        return Colors.red;
      case 'internal use':
        return Colors.blue;
      case 'other':
        return Colors.black;
      case 'in':
        return Colors.green;
      case 'out':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  static copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      "Alert",
      "Copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    return;
  }

  static getFirtLetter(String fully_paid) {
    if (fully_paid.isEmpty) {
      return '';
    }
    return fully_paid[0].toUpperCase();
  }
}
