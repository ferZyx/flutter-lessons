import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const CompassApp());
}

class CompassApp extends StatelessWidget {
  const CompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CompassScreen(),
    );
  }
}

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  double _azimuth = 0;

  @override
  void initState() {
    super.initState();

    List<double> accelerometerValues = [0, 0, 0];
    List<double> magnetometerValues = [0, 0, 0];

    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        accelerometerValues = [event.x, event.y, event.z];
      });
    });

    magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        magnetometerValues = [event.x, event.y, event.z];
      });

      _azimuth = calculateAzimuth(accelerometerValues, magnetometerValues);
    });
  }

  double calculateAzimuth(List<double> accel, List<double> mag) {
    double ax = accel[0], ay = accel[1], az = accel[2];
    double mx = mag[0], my = mag[1], mz = mag[2];

    double normAccel = math.sqrt(ax * ax + ay * ay + az * az);
    ax /= normAccel;
    ay /= normAccel;
    az /= normAccel;

    double normMag = math.sqrt(mx * mx + my * my + mz * mz);
    mx /= normMag;
    my /= normMag;
    mz /= normMag;

    double hx = my * az - mz * ay;
    double hy = mz * ax - mx * az;
    double azimuth = math.atan2(hy, hx) * (180 / math.pi);

    return (azimuth >= 0 ? azimuth : azimuth + 360);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Компас')),
      body: Center(
        child: Transform.rotate(
          angle: (_azimuth * (math.pi / 180) * -1),
          child: Image.asset('assets/compass.png', scale: 5,),
        ),
      ),
    );
  }
}
