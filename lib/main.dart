import 'package:flutter/material.dart';

void main() => runApp(const BMICalculatorApp());

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String result = "";

  void calculateBMI() {
    double weight = double.parse(
        weightController.text);
    double height =
        double.parse(heightController.text) / 100;

    double bmi = weight / (height * height);

    String bmiCategory = "";
    if (bmi < 16) {
      bmiCategory = "Острый дефицит массы";
    } else if (bmi >= 16 && bmi <= 18.5) {
      bmiCategory = "Недостаточная масса тела";
    } else if (bmi > 18.5 && bmi <= 25) {
      bmiCategory = "Норма";
    } else if (bmi > 25 && bmi <= 30) {
      bmiCategory = "Избыточная масса тела";
    } else if (bmi > 30 && bmi <= 35) {
      bmiCategory = "Ожирение первой степени";
    } else if (bmi > 35 && bmi <= 40) {
      bmiCategory = "Ожирение второй степени";
    } else if (bmi > 40) {
      bmiCategory = "Ожирение третьей степени";
    }

    setState(() {
      result = "Ваш ИМТ: ${bmi.toStringAsFixed(1)} ($bmiCategory)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор ИМТ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                labelText: 'Вес (кг)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: heightController,
              decoration: const InputDecoration(
                labelText: 'Рост (см)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: calculateBMI,
              child: const Text('Рассчитать ИМТ'),
            ),
            const SizedBox(height: 16),

            Text(
              result,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
