import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:decimal/decimal.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  // output displayed on the calculator screen
  String _output = "0";

  // buffer to store the input expression
  final List<String> _buffer = [];

  // buttons on the calculator
  // these are ordered in a way that they will be displayed on the calculator
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
    // set the color of the '=' button to a different color
    Color buttonColor = buttonText == '='
        ? const Color.fromARGB(237, 72, 132, 152)
        : Colors.white60;

    // set the color of the operands to a different color
    buttonColor = buttonText == '÷' ||
            buttonText == 'x' ||
            buttonText == '+' ||
            buttonText == '-'
        ? Color.fromARGB(236, 40, 137, 72)
        : buttonColor;

    // calculator button widget and styling
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: TextStyle(
                  color: buttonColor,
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
      // clear the screen
      setState(() {
        _buffer.clear();
        _output = "0";
      });
    } else if (buttonText == 'backspace') {
      // Remove the last character from the buffer and screen
      setState(() {
        if (_buffer.isNotEmpty) {
          _buffer.removeLast();
        }

        // two of the same if statement:
        // when put in the same clause, results to a bug where an empty buffer
        // cannot be joined
        if (_buffer.isNotEmpty) {
          _output = _buffer.join();
        } else {
          _output = "0";
        }
      });
    } else if (buttonText == '=') {
      // evaluate the expression
      String expression = _buffer.join();
      // replace the 'x' symbol with '*'
      expression = expression.replaceAll('x', '*');
      // replace the '÷' symbol with '/'
      expression = expression.replaceAll('÷', '/');

      // checks if the expression is valid
      try {
        final Parser p = Parser();
        final Expression exp = p.parse(expression);
        final ContextModel cm = ContextModel();

        // TODO: Use the Decimal class to handle floating point numbers
        Decimal eval =
            Decimal.parse(exp.evaluate(EvaluationType.REAL, cm).toString());

        setState(() {
          // check if the result is an integer
          _output = eval % Decimal.one == Decimal.zero
              ? eval.toStringAsFixed(0)
              : eval.toString();
          _buffer.clear();

          // TODO: Allow continuous calculations
          // add the result to the buffer
          // this allows the user to continue with the calculation
          // _buffer.add(_output);
        });
      } catch (e) {
        // display an error message
        setState(() {
          _output = "Error";
          _buffer.clear();
        });
      }
    } else {
      // add the button text to the buffer which will be displayed on the screen
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
        // Display / Screen
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              alignment: Alignment.bottomRight,
              child: FittedBox(
                // to make the text fit the screen
                fit: BoxFit.scaleDown,
                child: Text(
                  _output,
                  style: const TextStyle(
                    fontSize: 80.0, // starting size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Clear and Backspace buttons
        Container(
            color: Colors.black26, // acts as a divider
            height: 100,
            width: double.infinity,
            padding: const EdgeInsetsDirectional.only(start: 8.0, end: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  // control the width of the button
                  width: 100,
                  child: TextButton(
                    // clear button
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
                    // backspace button
                    onPressed: () {
                      handleCalculation('backspace');
                    },
                    icon: const Icon(
                      Icons.backspace,
                      color: Colors.white60,
                      size: 30.0,
                    ),
                  ),
                )
              ],
            )),

        // Keyboard
        Expanded(
          flex: 2, // to make the keyboard take up more space
          child: GridView.count(
            // to display the buttons in a grid
            crossAxisCount: 4,
            children: _buttons // create the buttons
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
