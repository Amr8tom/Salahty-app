import 'package:al_quran/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DrawerUtils {
  static const List<Map<String, dynamic>> items = [
    {
      'title': 'فهرس السور', // Surah Index
      'icon': Iconsax.sort,
      'route': AppRoutes.surah,
    },
    {
      'title': 'فهرس الأجزاء', // Juz Index
      'icon': Iconsax.note_1,
      'route': AppRoutes.juz,
    },
    {
      'title': 'مواقيت الصلاة', // Bookmarks
      'icon': Iconsax.timer,
      'route': AppRoutes.azan,
    },
    {
      'title': 'الإشارات المرجعية', // Bookmarks
      'icon': Iconsax.book_1,
      'route': AppRoutes.bookmarks,
    },
    {
      "title": 'اتجاه القبلة',
      "icon": Icons.explore_rounded,
      'route': AppRoutes.qibla,
    }
    ];
}