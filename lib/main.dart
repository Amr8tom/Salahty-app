import 'package:al_quran/cubits/Azan/azan_cubit.dart';
import 'package:al_quran/ui/screens/azan/azan_screen.dart';
import 'package:al_quran/ui/screens/qibla_direction/qibla_direction_screen.dart';
import 'package:al_quran/utils/azan_player.dart';
import 'package:al_quran/utils/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:al_quran/app_routes.dart';
import 'package:al_quran/cubits/bookmarks/cubit.dart';
import 'package:al_quran/cubits/chapter/cubit.dart';
import 'package:al_quran/cubits/juz/cubit.dart';
import 'package:al_quran/models/ayah/ayah.dart';
import 'package:al_quran/models/chapter/chapter.dart';
import 'package:al_quran/models/juz/juz.dart';
import 'package:al_quran/providers/app_provider.dart';
import 'package:al_quran/providers/onboarding_provider.dart';
import 'package:al_quran/ui/screens/bookmarks/bookmarks_screen.dart';
import 'package:al_quran/ui/screens/home/home_screen.dart';
import 'package:al_quran/ui/screens/juz/juz_index_screen.dart';
import 'package:al_quran/ui/screens/splash/splash.dart';
import 'package:al_quran/ui/screens/surah/surah_index_screen.dart';
import 'package:workmanager/workmanager.dart';




import 'configs/core_theme.dart' as theme;
import 'cubits/Azan/data_provider.dart';
import 'models/azan_by_city/azan_model.dart';
void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await GetLocation.getLatLang();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "azanUpdate",
    "fetchAzanTimes",
    frequency: Duration(days: 1), // Runs every 24 hours
  );

  // hive
  await Hive.initFlutter();
  Hive.registerAdapter<Juz>(JuzAdapter());
  Hive.registerAdapter<Ayah>(AyahAdapter());
  Hive.registerAdapter<Chapter>(ChapterAdapter());

  await Future.wait([
    Hive.openBox('app'),
    Hive.openBox('data'),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}
class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => JuzCubit()),
        BlocProvider(create: (_) => ChapterCubit()),
        BlocProvider(create: (_) => AzanCubit()),
        BlocProvider(create: (_) => BookmarkCubit()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => OnBoardingProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, value, child) {
          return MaterialChild(
            value: value,
          );
        },
      ),
    );
  }
}

class MaterialChild extends StatelessWidget {
  final AppProvider? value;
  const MaterialChild({
    super.key,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salahty',
      debugShowCheckedModeBanner: false,
      theme: theme.themeLight,
      darkTheme: theme.themeLight,
      themeMode: value!.themeMode,
      initialRoute: AppRoutes.splash,
      routes: <String, WidgetBuilder>{
        AppRoutes.juz: (context) => const JuzIndexScreen(),
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.surah: (context) => const SurahIndexScreen(),
        AppRoutes.azan: (context) => const AzanScreen(),
        AppRoutes.bookmarks: (context) => const BookmarksScreen(),
        AppRoutes.qibla: (context) => const QiblaDirectionScreen(),
        AppRoutes.home: (context) =>
            HomeScreen(maxSlide: MediaQuery.of(context).size.width * 0.835),
      },
    );
  }
}



// ✅ WorkManager callback (MUST NOT take parameters)
// void callbackDispatcher() {
//   print("WorkManager Task Running: Fetching Azan Times");
//   print("WorkManager Task Running: Fetching Azan Times");
//   print("WorkManager Task Running: Fetching Azan Times");
//   Workmanager().executeTask((task, inputData) async {
//     print("WorkManager Task Running: Fetching Azan Times");
//     print("WorkManager Task Running: Fetching Azan Times");
//     print("WorkManager Task Running: Fetching Azan Times");
//     final AzanModel data = await AzanDataProvider.azanFetchApi(latitude: GetLocation.pos!.longitude.toString(),longitude:GetLocation.pos!.longitude.toString());
//
//     final timings =data.data?.timings;
//
//     final azanNotifications = AzanNotifications();
//     azanNotifications.init().then((_) {
//       azanNotifications.scheduleAzanNotifications({
//         'الفجر': timings?.fajr,
//         'الظهر': timings?.dhuhr,
//         'العصر': timings?.asr,
//         'المغرب': timings?.maghrib,
//         'العشاء': timings?.isha,
//       });
//       print("WorkManager Task Running: Fetching Azan Times");
//       print("WorkManager Task Running: Fetching Azan Times");
//       print("WorkManager Task Running: Fetching Azan Times");
//
//     });
//
//     return Future.value(true);
//   });
// }

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("📢 WorkManager Task Started: Fetching Azan Times");

    try {
      // ✅ Ensure Location is fetched properly before use
      if (GetLocation.pos == null) {
        print("❌ ERROR: Location is null. Cannot fetch Azan times.");
        return Future.value(false);
      }

      // ✅ Fix incorrect use of longitude/latitude
      final AzanModel data = await AzanDataProvider.azanFetchApi(
        latitude: GetLocation.pos!.latitude.toString(),
        longitude: GetLocation.pos!.longitude.toString(),
      );

      final timings = data.data?.timings;
      if (timings == null) {
        print("❌ ERROR: Failed to fetch Azan times from API.");
        return Future.value(false);
      }

      // ✅ Schedule Notifications with Correct Data
      final azanNotifications = AzanNotifications();
      await azanNotifications.init();
       azanNotifications.scheduleAzanNotifications({
        'الفجر': timings.fajr,
        'الظهر': timings.dhuhr,
        'العصر': timings.asr,
        'المغرب': timings.maghrib,
        'العشاء': timings.isha,
      });

      print("✅ WorkManager Task Completed: Azan Times Updated.");
      return Future.value(true);
    } catch (e) {
      print("❌ WorkManager Task Failed: $e");
      return Future.value(false);
    }
  });
}

