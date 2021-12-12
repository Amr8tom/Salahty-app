import 'package:al_quran/darkModeController/darkThemeProvider.dart';
import 'package:al_quran/darkModeController/themeStyle.dart';
import 'package:al_quran/model/ayat/ayat.dart';
import 'package:al_quran/model/juzz/juz.dart';
import 'package:al_quran/model/juzz/juz_list.dart';
import 'package:al_quran/model/sajda/sajda.dart';
import 'package:al_quran/model/sajda/sajda_list.dart';
import 'package:al_quran/model/surah/surah.dart';
import 'package:al_quran/model/surah/surah_list.dart';
import 'package:al_quran/view/juzz/JuzIndex_view.dart';
import 'package:al_quran/view/homeScreen_view.dart';
import 'package:al_quran/view/otherViews/help.dart';
import 'package:al_quran/view/otherViews/introduction.dart';
import 'package:al_quran/view/otherViews/shareApp.dart';
import 'package:al_quran/view/sajda/sajdaIndex_view.dart';
import 'package:al_quran/view/surahas/surahIndex_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);

  // hive
  // hive
  await Hive.initFlutter();

  // hive adapter
  Hive.registerAdapter<Ayat>(AyatAdapter());

  Hive.registerAdapter<JuzList>(JuzListAdapter());
  Hive.registerAdapter<JuzAyahs>(JuzAyahsAdapter());

  Hive.registerAdapter<SajdaList>(SajdaListAdapter());
  Hive.registerAdapter<SajdaAyat>(SajdaAyatAdapter());

  Hive.registerAdapter<SurahsList>(SurahsListAdapter());
  Hive.registerAdapter<Surah>(SurahAdapter());

  // box
  await Hive.openBox('data');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider darkThemeProvider = DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  void getCurrentAppTheme() async {
    darkThemeProvider.darkTheme =
        await darkThemeProvider.darkThemePref.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ChangeNotifierProvider(create: (_) {
      return darkThemeProvider;
    }, child: Consumer<DarkThemeProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return MaterialApp(
          title: "They Holy Qur'an",
          debugShowCheckedModeBanner: false,
          theme: ThemeStyles.themeData(darkThemeProvider.darkTheme, context),
          home: Builder(
            builder: (context) => HomeScreen(
              maxSlide: MediaQuery.of(context).size.width * 0.835,
            ),
          ),
          initialRoute: initScreen == 0 || initScreen == null
              ? '/introduction'
              : '/homeScreen',
          routes: <String, WidgetBuilder>{
            '/introduction': (context) => OnBoardingCard(),
            '/homeScreen': (context) => HomeScreen(
                  maxSlide: MediaQuery.of(context).size.width * 0.835,
                ),
            '/surahIndex': (context) => SurahIndex(),
            '/sajda': (context) => Sajda(),
            '/juzIndex': (context) => JuzIndex(),
            '/help': (context) => Help(),
            '/shareApp': (context) => ShareApp()
          },
        );
      },
    ));
  }
}
