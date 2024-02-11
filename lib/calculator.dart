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
    '÷',
    '4',
    '5',
    '6',
    'x',
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
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void handleCalculation(String buttonText) {
    if (buttonText == 'C') {
      setState(() {
        _buffer.clear();
        _output = "0";
      });
    } else if (buttonText == 'backspace') {
      setState(() {
        if (_buffer.isNotEmpty) {
          _buffer.removeLast();
        }
        _output = _buffer.join();
      });
    } else if (buttonText == '=') {
      String expression = _buffer.join();
      // replace the 'x' symbol with '*'
      expression = expression.replaceAll('x', '*');
      // replace the '÷' symbol with '/'
      expression = expression.replaceAll('÷', '/');
      try {
        final Parser p = Parser();
        final Expression exp = p.parse(expression);
        final ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);

        setState(() {
          // check if the result is an integer
          _output = eval % 1 == 0 ? eval.toInt().toString() : eval.toString();
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Display
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              alignment: Alignment.bottomRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                child: Text(
                  _output,
                  style: const TextStyle(
                    fontSize: 80.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),

        Container(
            color: Colors.black26,
            height: 100,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: TextButton(
                    onPressed: () {
                      handleCalculation('C');
                    },
                    child: const Text(
                      'C',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: IconButton(
                    onPressed: () {
                      handleCalculation('backspace');
                    },
                    icon: const Icon(
                      Icons.backspace,
                      color: Colors.white60,
                      size: 40.0,
                    ),
                  ),
                )
              ],
            )),

        // Keyboard
        Expanded(
          flex: 2,
          child: GridView.count(
            crossAxisCount: 4,
            children: _buttons
                .map((buttonText) => _buildButton(
                      buttonText,
                      onPressed: () {
                        handleCalculation(buttonText);
                      },
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
