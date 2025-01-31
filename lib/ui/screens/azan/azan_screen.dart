import 'package:al_quran/comman/AppBar.dart';
import 'package:al_quran/utils/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../configs/app.dart';
import '../../../configs/app_typography.dart';
import '../../../cubits/Azan/azan_cubit.dart';
import '../../../utils/azan_player.dart';
import '../../widgets/loader/loading_shimmer.dart';

class AzanScreen extends StatefulWidget {
  const AzanScreen({super.key});

  @override
  State<AzanScreen> createState() => _AzanScreenState();
}
class _AzanScreenState extends State<AzanScreen> {
  @override
  void initState() {
    super.initState();
    GetLocation.getLatLang(context: context);
    context.read<AzanCubit>().fetch(
        latitude: GetLocation.pos?.latitude.toString(),
        longitude: GetLocation.pos?.longitude.toString());
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Scaffold(
      appBar: DAppBar(
        actions: [],
        enableGradient: false,
        title: "مواقيت الصلاة",
        bgColor: Colors.transparent,
        showBackArrow: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(

            image: const AssetImage('assets/images/pageBG.png',),
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,

            colorFilter: ColorFilter.mode(
                Color(0xFF203A43),
              BlendMode.darken,
            ),
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<AzanCubit>().fetch(
                latitude: GetLocation.pos?.latitude.toString(),
                longitude: GetLocation.pos?.longitude.toString()
            );
          },
          child: Stack(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 100),
                child:



                BlocBuilder<AzanCubit, AzanState>(
                  builder: (context, state) {
                    if (state is AzanFetchLoading) {
                      return const Center(
                        child: LoadingShimmer(
                          text: 'جارِ تحميل مواقيت الصلاة...',
                        ),
                      );
                    } else if (state is AzanFetchSuccess) {
                      final timings = state.azanData.data?.timings;

                      if (timings == null) {
                        return _buildMessage("لا توجد أوقات صلاة متوفرة.");
                      }

                      /// Schedule notifications when timings are fetched
                      final azanNotifications = AzanNotificaions();
                      azanNotifications.init().then((_) {
                        azanNotifications.scheduleAzanNotifications({
                          'الفجر': timings.fajr,
                          'الظهر': timings.dhuhr,
                          'العصر': timings.asr,
                          'المغرب': timings.maghrib,
                          'العشاء': timings.isha,
                        });
                      });

                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          const SizedBox(height: 130),
                          _buildAzanCard(
                              'الفجر', timings.fajr, Icons.wb_sunny_outlined),
                          _buildAzanCard(
                              'الظهر', timings.dhuhr, Icons.wb_sunny),
                          _buildAzanCard('العصر', timings.asr, Icons.wb_cloudy),
                          _buildAzanCard(
                              'المغرب', timings.maghrib, Icons.nights_stay),
                          _buildAzanCard(
                              'العشاء', timings.isha, Icons.nightlight_round),
                        ],
                      );
                    } else if (state is AzanFetchFailed) {
                      return _buildMessage(
                          "فشل في تحميل مواقيت الصلاة. الرجاء المحاولة مرة أخرى.");
                    }

                    return _buildMessage(
                        "حدث خطأ غير متوقع. الرجاء إعادة المحاولة.");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AzanCubit>().fetch(
              latitude: GetLocation.pos?.latitude.toString(),
              longitude: GetLocation.pos?.longitude.toString());
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.refresh, color: Colors.black),
        tooltip: "تحديث",
      ),
    );
  }

  Widget _buildAzanCard(String title, String? time, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.black.withOpacity(0.6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber.shade200,
          child: Icon(icon, color: Colors.black),
        ),
        title: Text(
          title,
          style: AppText.b1?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        trailing: Text(
          time ?? 'غير متوفر',
          style: AppText.b1?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Text(
        message,
        style: AppText.b1?.copyWith(
          fontSize: 18,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
