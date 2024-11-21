import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  TextEditingController _controller = TextEditingController();
  String _message = '';

  void _incrementCounter() {
    final String input = _controller.text;

    // Якщо введено "Avada Kedavra", скинути лічильник
    if (input.toLowerCase() == "avada kedavra") {
      setState(() {
        _counter = 0;
        _message = 'Counter reset by magic!';
      });
    }
    // Якщо введене значення можна перетворити на число
    else if (int.tryParse(input) != null) {
      setState(() {
        _counter += int.parse(input);
        _message = 'Added $input to the counter!';
      });
    }
    // Якщо це не число і не магічне слово
    else {
      setState(() {
        _message = 'Invalid input, please enter a number or the magic phrase!';
      });
    }

    // Очистити поле введення
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Counter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Counter: $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter number or magic phrase',
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(color: Colors.yellow, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
