import 'package:al_quran/comman/AppBar.dart';
import 'package:al_quran/ui/animations/bottom_animation.dart';
import 'package:al_quran/configs/app.dart';
import 'package:al_quran/configs/configs.dart';
import 'package:al_quran/cubits/juz/cubit.dart';
import 'package:al_quran/ui/screens/surah/surah_index_screen.dart';
import 'package:al_quran/utils/juz.dart';
import 'package:al_quran/ui/widgets/flare.dart';
import 'package:flutter/material.dart';



class JuzIndexScreen extends StatefulWidget {
  const JuzIndexScreen({super.key});

  @override
  State<JuzIndexScreen> createState() => _JuzIndexScreenState();
}

class _JuzIndexScreenState extends State<JuzIndexScreen> {
  int _searchedIndex = -1;
  String _searchedJuzName = '';

  @override
  Widget build(BuildContext context) {

    App.init(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final juzCubit = JuzCubit.cubit(context);

    bool hasSearched = _searchedIndex != -1 && _searchedJuzName.isNotEmpty;

    return Scaffold(
      appBar: DAppBar(
        actions: [],
        enableGradient: false,
        bgColor: Colors.transparent,
        showBackArrow: true,
        title: "فهرس الأجزاء",
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027), // Deep Teal
              Color(0xFF203A43), // Teal
              Color(0xFF3A5963), // Teal
              Color(0xFFF3CA40), // Golden Yellow
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _searchedIndex = -1;
                          _searchedJuzName = '';
                        } else if (int.tryParse(value) != null &&
                            int.parse(value) > 0 &&
                            int.parse(value) <= JuzUtils.juzNames.length) {
                          _searchedIndex = int.parse(value);
                          _searchedJuzName = JuzUtils.juzNames[_searchedIndex - 1];
                        } else {
                          _searchedIndex = -1;
                          _searchedJuzName = '';
                        }
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      hintText: 'ابحث عن رقم الجزء...',
                      hintStyle: AppText.b2?.copyWith(color: Colors.white70,fontSize: 22,),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 40,
                        color: Colors.amber,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.14,
                  ),
                  child: hasSearched
                      ? GestureDetector(
                          onTap: () async {
                            await juzCubit.fetch(
                              JuzUtils.juzNames.indexOf(_searchedJuzName) + 1,
                            );

                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PageScreen(
                                    juz: juzCubit.state.data,
                                  ),
                                ),
                              );
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white,
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _searchedJuzName,
                                    style: AppText.h2b,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          itemCount: JuzUtils.juzNames.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 5,
                                  crossAxisCount: 3 ,),
                          itemBuilder: (context, index) {
                            return WidgetAnimator(
                              child: GestureDetector(
                                onTap: () async {
                                  await juzCubit.fetch(index + 1);

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PageScreen(
                                          juz: juzCubit.state.data,
                                        ),
                                      ),
                                    );
                                  });
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  color: Colors.black.withOpacity(0.6),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                        width: 1,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          JuzUtils.juzNames[index],
                                          style: AppText.b1?.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.amber,
                                          ),                                      textAlign: TextAlign.center,
                                        ),
                                        // Space.y!,
                                        Text(
                                          '${index + 1}',
                                          style: AppText.b1?.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),                                    ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                ...[
                  Flare(
                    color: const Color(0xfff9e9b8),
                    offset: Offset(width, -height),
                    bottom: -50,
                    flareDuration: const Duration(seconds: 17),
                    left: 100,
                    height: 60,
                    width: 60,
                  ),
                  Flare(
                    color: const Color(0xfff9e9b8),
                    offset: Offset(width, -height),
                    bottom: -50,
                    flareDuration: const Duration(seconds: 12),
                    left: 10,
                    height: 25,
                    width: 25,
                  ),
                  Flare(
                    color: const Color(0xfff9e9b8),
                    offset: Offset(width, -height),
                    bottom: -40,
                    left: -100,
                    flareDuration: const Duration(seconds: 18),
                    height: 50,
                    width: 50,
                  ),
                  Flare(
                    color: const Color(0xfff9e9b8),
                    offset: Offset(width, -height),
                    bottom: -50,
                    left: -80,
                    flareDuration: const Duration(seconds: 15),
                    height: 50,
                    width: 50,
                  ),
                  Flare(
                    color: const Color(0xfff9e9b8),
                    offset: Offset(width, -height),
                    bottom: -20,
                    left: -120,
                    flareDuration: const Duration(seconds: 12),
                    height: 40,
                    width: 40,
                  ),
                ],
              ],
            )),
      ),
    );
  }
}
