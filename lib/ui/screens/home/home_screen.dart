import 'dart:io';
import 'dart:async';
import 'dart:math' as math;
import 'package:al_quran/configs/app.dart';
import 'package:al_quran/providers/app_provider.dart';
import 'package:al_quran/ui/screens/home/widgets/main_screen.dart';
import 'package:al_quran/utils/drawer.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:al_quran/configs/configs.dart';
import '../../../cubits/Azan/azan_cubit.dart';
import '../../../utils/geolocator.dart';

part 'widgets/bottom_ayah.dart';
part 'widgets/custom_drawer.dart';
class HomeScreen extends StatefulWidget {
  final double maxSlide;
  const HomeScreen({super.key, required this.maxSlide});

  @override
  HomeScreenState createState() => HomeScreenState();
}
class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    GetLocation.getLatLang(context: context);
    context.read<AzanCubit>().fetch(
        latitude: GetLocation.pos?.latitude.toString(),
        longitude: GetLocation.pos?.longitude.toString());

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350), // Smooth animation
    );
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  late bool _canBeDragged;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / widget.maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    const double kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }

    if (details.velocity.pixelsPerSecond.dx.abs() >= kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "خروج من التطبيق",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text("هل أنت متأكد أنك تريد الخروج؟"),
        actions: <Widget>[
          TextButton(
            child: const Text(
              "نعم",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            onPressed: () => exit(0),
          ),
          TextButton(
            child: const Text(
              "لا",
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    App.getLocation( context: context);
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        behavior: HitTestBehavior.translucent,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            return Material(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/islamic_pattern1.jpg'), // Islamic pattern image
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), // Adjust opacity
                      BlendMode.darken,
                    ),
                  ),
                ),

                child: Stack(
                  children: <Widget>[
                    // Custom Drawer
                    Transform.translate(
                      offset: Offset(
                          widget.maxSlide * (animationController.value - 1), 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(math.pi / 2 * (1 - animationController.value))
                          ..scale(0.95 + 0.05 * animationController.value),
                        alignment: Alignment.centerRight,
                        child: const _CustomDrawer(),
                      ),
                    ),

                    /// Main Screen
                    Transform.translate(
                      offset:
                      Offset(widget.maxSlide * animationController.value, 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(-math.pi / 2 * animationController.value),
                        alignment: Alignment.centerLeft,
                        child: const MainScreen(),
                      ),
                    ),

                    /// Menu Icon
                    Positioned(
                      top: 4.0 + MediaQuery.of(context).padding.top,
                      left: width * 0.02 +
                          animationController.value * widget.maxSlide,
                      child: IconButton(
                        icon: Icon(
                          Iconsax.menu,
                          size: AppDimensions.normalize(11),
                          color: Colors.white,
                        ),
                        onPressed: toggle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
