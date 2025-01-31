import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../comman/AppBar.dart';
import '../../../configs/app.dart';
import '../../../providers/app_provider.dart';

class QiblaDirectionScreen extends StatefulWidget {
  const QiblaDirectionScreen({super.key});

  @override
  _QiblaDirectionScreenState createState() => _QiblaDirectionScreenState();
}

class _QiblaDirectionScreenState extends State<QiblaDirectionScreen>
    with SingleTickerProviderStateMixin {
  double? _qiblaAngle;
  double _deviceHeading = 0.0;
  double _tiltAngle = 0.0;
  bool _isTiltSuitable = true;
  Position? _currentPosition;

  StreamSubscription? _magnetometerSubscription;
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _listenToDeviceSensors();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permission denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission permanently denied.");
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _currentPosition = position;

      const kaabaLat = 21.4225;
      const kaabaLon = 39.8262;
      final dLon = kaabaLon - position.longitude;

      final offsetInDegrees = 10.0; // Adjust the angle by 10 degrees to the right
      final offsetInRadians = offsetInDegrees * pi / 180;

      final qiblaRadians = atan2(
        sin(dLon * pi / 180) * cos(kaabaLat * pi / 180),
        cos(position.latitude * pi / 180) * sin(kaabaLat * pi / 180) -
            sin(position.latitude * pi / 180) *
                cos(kaabaLat * pi / 180) *
                cos(dLon * pi / 180),
      ) + offsetInRadians*9;


      setState(() {
        _qiblaAngle = (qiblaRadians * 180 / pi + 360) % 360;
      });
    } catch (e) {
      debugPrint("Error fetching location: $e");
      setState(() {
        _qiblaAngle = null;
      });
    }
  }

  void _listenToDeviceSensors() {
    _magnetometerSubscription = magnetometerEvents.listen((event) {
      final heading =
          atan2(event.y, event.x) * (180 / pi); // Calculate heading in degrees
      if (mounted) {
        setState(() {
          _deviceHeading = heading >= 0 ? heading : 360 + heading;
        });
      }
    });

    _accelerometerSubscription = accelerometerEvents.listen((event) {
      final tilt = atan2(
            event.z,
            sqrt(event.x * event.x + event.y * event.y),
          ) *
          (180 / pi);
      if (mounted) {
        setState(() {
          _tiltAngle = tilt.abs();
          _isTiltSuitable = _tiltAngle > 75 && _tiltAngle < 105;
        });
      }
    });
  }

  @override
  void dispose() {
    _magnetometerSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  double _calculateCorrectedQiblaDirection() {
    if (_qiblaAngle == null) return 0.0;
    final relativeQiblaAngle = (_qiblaAngle! - _deviceHeading) % 360;
    return relativeQiblaAngle >= 0
        ? relativeQiblaAngle
        : relativeQiblaAngle + 360;
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final appProvider = Provider.of<AppProvider>(context);
    final correctedQiblaDirection = _calculateCorrectedQiblaDirection();

    return Scaffold(
      appBar: DAppBar(
        actions: [],
        title: "اتجاه القبلة",
        bgColor: Colors.transparent,
        showBackArrow: true,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: appProvider.isDark ? Colors.grey[850] : Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF002F5E), Color(0xFF193A77), Color(0xFFD4AF37)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isTiltSuitable ? Colors.amber : Colors.white,
                    width: 4,
                  ),
                  gradient: RadialGradient(
                    colors: _isTiltSuitable
                        ? const [Color(0xFFD4AF37), Color(0xFF002F5E)]
                        // : [Color(0xFF430807), Color(0xFF5E0035)],
                        : const [Colors.transparent,Colors.red],
                    center: Alignment(0.0, 0.0),
                    radius: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isTiltSuitable
                          ? Colors.amber.withOpacity(0.4)
                          : Colors.red.withOpacity(0.4),
                      spreadRadius: 8,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              (_qiblaAngle != null && _isTiltSuitable)
                  ? Transform.rotate(
                      angle: correctedQiblaDirection * (pi / 180),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.navigation,
                            size: 100,
                            color: Colors.white,
                          ),
                          const Text(
                            "اتجاه القبله للصلاه",
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 100,
                          color: Colors.white,
                        ),
                        const Text(
                          "يرجى وضع الهاتف على سطح مستوٍ\n للتمكن من تحديد القبله.",
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 18,
                              fontWeight:FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
              Positioned(
                bottom: 50,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "اتجاه الجهاز: ${_deviceHeading.toStringAsFixed(2)}°",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "زاوية القبلة: ${_qiblaAngle?.toStringAsFixed(2)}°",
                      style: const TextStyle(color: Colors.amber, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
