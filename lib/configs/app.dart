import 'package:flutter/material.dart';

import '../utils/geolocator.dart';
import 'ui.dart';
import 'space.dart';
import 'ui_props.dart';
import 'app_theme.dart';
import 'app_typography.dart';
import 'app_dimensions.dart';

class App {
  static bool? isLtr;
  static bool showAds = false;

  static init(BuildContext context) {
    UI.init(context);
    AppDimensions.init();
    AppTheme.init(context);
    UIProps.init();
    Space.init();
    AppText.init();
    isLtr = Directionality.of(context) == TextDirection.ltr;

  }
  static Future<void> getLocation({required BuildContext context})async{

    await GetLocation.getLatLang(context: context);
    print(GetLocation.pos?.longitude.toString());
    print(GetLocation.pos?.longitude.toString());
    print(GetLocation.pos?.longitude.toString());
    print(GetLocation.pos?.longitude.toString());
  }
}
