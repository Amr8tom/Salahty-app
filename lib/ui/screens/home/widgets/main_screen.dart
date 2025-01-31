import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_routes.dart';
import '../../../../configs/app_typography.dart';

import '../../../../cubits/Azan/azan_cubit.dart';
import '../../../../utils/azan_player.dart';
import '../../../widgets/quran_rail.dart';

class MainScreen extends StatelessWidget {
  const MainScreen();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027), // Deep Teal
              Color(0xFF203A43), // Teal
              Color(0xFFF3CA40), // Golden Yellow
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child:  BlocListener<AzanCubit, AzanState>(
            listener: (context, state) {
              if (state is AzanFetchSuccess) {
                final timings = state.azanData.data?.timings;
                /// Schedule notifications when timings are fetched
                final azanNotifications = AzanNotificaions();
                azanNotifications.init().then((_) {
                  azanNotifications.scheduleAzanNotifications({
                    'الفجر': timings?.fajr,
                    'الظهر': timings?.dhuhr,
                    'العصر': timings?.asr,
                    'المغرب': timings?.maghrib,
                    'العشاء': timings?.isha,
                  });
                });

              }
            },


  child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                right: 20,
                top: 15,
                child: Icon(
                  Icons.brightness_3, // Crescent Moon Icon
                  color: Colors.white70,
                  size: 40,
                ),
              ),
              const QuranRail(),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [

                    Text(
                      "القرآن الكريم",
                      style: AppText.h1?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),

                    ),

                    // const SizedBox(height: 8),
                    Text(
                      "نور قلبك بذكر الله",
                      style: AppText.b1?.copyWith(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AppButton2(
                      title: 'السور',
                      icon: Icons.menu_book_rounded,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.surah),
                    ),
                    const SizedBox(height: 16),
                    AppButton2(
                      title: 'الأجزاء',
                      icon: Icons.format_list_numbered_rtl,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.juz),
                    ),

                    const SizedBox(height: 16),
                    AppButton2(
                      title: 'اتجاه القبلة',
                      icon: Icons.explore_rounded,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.qibla),
                    ),
                    const SizedBox(height: 16),
                    AppButton2(
                      title: 'مواقيت الصلاة',
                      icon: Icons.access_time,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.azan),
                    ),
                    const SizedBox(height: 16),
                    AppButton2(
                      title: 'الإشارات المرجعية',
                      icon: Icons.bookmark_border,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.bookmarks),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "© 2025 - Islamic App",
                    style: AppText.b2?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),

            
            ],
          ),
),
        ),
      ),
    );
  }
}

class AppButton2 extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onPressed;

  const AppButton2({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 90% width of screen
      height: 65, // Increased height for better accessibility
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white38),
        boxShadow: [
          BoxShadow(
            color: Colors.yellowAccent.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppText.b1?.copyWith(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: "AmiriQuran"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
