import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ui/screens/Auth/LandingScreen.dart';
import 'package:flutter_ui/screens/MenuRoute.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'data/my_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    builder: EasyLoading.init(),
    theme: MyColors.getTheme(),
    home: LandingScreen(),
    routes: <String, WidgetBuilder>{
      '/LandingScreen': (BuildContext context) => new LandingScreen(),
      '/MenuRoute': (BuildContext context) => new MenuRoute(),
    },
  ));
}
