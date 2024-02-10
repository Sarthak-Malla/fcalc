import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";

  final List<String> _buffer = [];

  final List<String> _buttons = [
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    '*',
    '1',
    '2',
    '3',
    '+',
    '.',
    '0',
    '=',
    '-',
  ];

  Widget _buildButton(String buttonText, {VoidCallback? onPressed}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Display
        Expanded(
          child: Container(
            alignment: Alignment.bottomRight,
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
            child: Text(
              _output,
              style: const TextStyle(
                fontSize: 80.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Keyboard

        // Keyboard
        Expanded(
          flex: 2,
          child: GridView.count(
            crossAxisCount: 4,
            children: _buttons
                .map((buttonText) => _buildButton(
                      buttonText,
                      onPressed: () {
                        if (buttonText == '=') {
                          final String expression = _buffer.join();
                          try {
                            final Parser p = Parser();
                            final Expression exp = p.parse(expression);
                            final ContextModel cm = ContextModel();
                            final double eval =
                                exp.evaluate(EvaluationType.REAL, cm);
                            setState(() {
                              _output = eval.toString();
                              _buffer.clear();
                            });
                          } catch (e) {
                            setState(() {
                              _output = "Error";
                              _buffer.clear();
                            });
                          }
                        } else {
                          setState(() {
                            _buffer.add(buttonText);
                            _output = _buffer.join();
                          });
                        }
                      },
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
