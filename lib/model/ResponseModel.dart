import 'dart:convert';

class ResponseModel {
  int code = 0;
  String message = "";
  dynamic data = null;

  dynamic raw;

  ResponseModel(this.raw) {
    if (raw == null) {
      return;
    }

    if (!raw.runtimeType.toString().toLowerCase().contains('map')) {
      if (raw.toString().isEmpty) {
        return;
      }
      try {
        raw = fromJson(json.decode(raw));
      } catch (e) {
        return;
      }
      return;
    }
    code = int.parse(raw['code'].toString());
    message = raw['message'].toString();
    data = raw['data'];
  }

  //from json
  fromJson(dynamic m) {
    if (m == null) {
      return;
    }
    code = int.parse(m['code'].toString());
    message = m['message'].toString();
    data = m['data'];
  }
}
