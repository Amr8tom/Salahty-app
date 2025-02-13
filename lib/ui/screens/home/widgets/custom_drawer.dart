part of '../home_screen.dart';

class _CustomDrawer extends StatelessWidget {
  const _CustomDrawer();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final appProvider = Provider.of<AppProvider>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: width * 0.8,
      height: height,
      child: Container(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Drawer Header
                Row(
                  children: [
                    Icon(
                      Icons.brightness_3, // Crescent Moon Icon
                      color: Colors.white70,
                      size: 40,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "تطبيق القرآن الكريم",
                      style: AppText.h1?.copyWith(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "AmiriQuran",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// Drawer Items
                Expanded(
                  child: ListView.builder(
                    itemCount: DrawerUtils.items.length,
                    itemBuilder: (context, index) {
                      final item = DrawerUtils.items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '${item['route']}',
                                arguments: {'route': 'drawer'},
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.yellowAccent.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item['icon'],
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    item['title'],
                                    style: AppText.b1?.copyWith(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "AmiriQuran",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// Dark Mode Toggle
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                //   child: Container(
                //     padding: const EdgeInsets.all(16),
                //     decoration: BoxDecoration(
                //       color: Colors.white.withOpacity(0.1),
                //       borderRadius: BorderRadius.circular(15),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.greenAccent.withOpacity(0.3),
                //           blurRadius: 10,
                //           spreadRadius: 1,
                //         ),
                //       ],
                //     ),
                //     child: Row(
                //       children: [
                //         Icon(
                //           Icons.surround_sound_outlined, // Moon Icon for Dark Mode
                //           color: Colors.white,
                //           size: 28,
                //         ),
                //         const SizedBox(width: 16),
                //         Expanded(
                //           child: Text(
                //             "تفعيل الاذان",
                //             style: AppText.b1?.copyWith(
                //               fontSize: 18,
                //               color: Colors.white,
                //               fontWeight: FontWeight.w600,
                //               fontFamily: "AmiriQuran",
                //             ),
                //           ),
                //         ),
                //         Switch(
                //           value: appProvider.isDark,
                //           activeColor: Colors.yellowAccent,
                //           onChanged: (value) {
                //             if (value) {
                //               appProvider.setTheme(ThemeMode.dark);
                //             } else {
                //               appProvider.setTheme(ThemeMode.light);
                //             }
                //           },
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                /// Footer
                const SizedBox(height: 50,),
                Divider(
                  color: Colors.white38,
                  thickness: 0.5,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "الإصدار 1.0.0",
                    style: AppText.b2?.copyWith(
                      color: Colors.white54,
                      fontFamily: "AmiriQuran",
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
