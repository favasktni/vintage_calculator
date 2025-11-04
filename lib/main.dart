import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const VintageCalculatorApp());
}

class VintageCalculatorApp extends StatelessWidget {
  const VintageCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VintageCalculator(),
    );
  }
}

class VintageCalculator extends StatefulWidget {
  const VintageCalculator({super.key});

  @override
  State<VintageCalculator> createState() => _VintageCalculatorState();
}

class _VintageCalculatorState extends State<VintageCalculator> {
  String userInput = '';
  String result = '';

  // 🎨 Vintage color palette
  final Color darkGreen = const Color(0xFF284d24);
  final Color lightGreen = const Color(0xFF4e8a4a);
  final Color neonGreen = const Color(0xFF76ff7a);
  final Color background = Colors.black;
  final double borderRadius = 18.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10),

            // Title
            Text(
              "Cassio",
              style: TextStyle(
                color: neonGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),

            // Display screen
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              height: 160,
              decoration: BoxDecoration(
                color: darkGreen,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: lightGreen, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: neonGreen.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      userInput,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: neonGreen,
                        fontSize: 24,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: neonGreen.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: neonGreen,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 20,
                            color: neonGreen.withOpacity(0.9),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Button pad
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: darkGreen,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(color: lightGreen, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButtonRow(['C', '%', 'D', '/']),
                    buildButtonRow(['7', '8', '9', '*']),
                    buildButtonRow(['4', '5', '6', '-']),
                    buildButtonRow(['1', '2', '3', '+']),
                    buildButtonRow(['00', '0', '.', '=']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Builds each row of buttons
  Widget buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons
            .map((btnText) => Expanded(child: buildButton(btnText)))
            .toList(),
      ),
    );
  }

  // 🔹 Single button widget (responsive + square)
  Widget buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: AspectRatio(
        aspectRatio: 1, // Keeps buttons perfectly square
        child: ElevatedButton(
          onPressed: () => onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: lightGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            shadowColor: Colors.black54,
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Button press logic
  void onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        userInput = '';
        result = '';
      } else if (text == 'D') {
        if (userInput.isNotEmpty) {
          userInput = userInput.substring(0, userInput.length - 1);
        }
      } else if (text == '=') {
        calculateResult();
      } else {
        userInput += text;
      }
    });
  }

  // 🔹 Calculate expression
  void calculateResult() {
    try {
      String finalInput = userInput.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(finalInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      result = eval.toString();
    } catch (e) {
      result = "Error";
    }
  }
}
