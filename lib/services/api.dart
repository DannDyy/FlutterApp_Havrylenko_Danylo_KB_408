import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchRandomQuote() async {
  final url = Uri.parse('https://excuser-three.vercel.app/v1/excuse/college/');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final quote = data[0]['excuse'];
      return '$quote';
    } else {
      throw Exception('Помилка завантаження');
    }
  } catch (e) {
    return 'Виникла помилка: $e';
  }
}

Future<String> fetchWeather() async {
  final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=49.84&lon=24.03&units=metric&appid=55818721c047b9143fba3999c735c686');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final weather = data['weather'][0]['main'];
      final temperature = data['main']['temp'].toString();
      final temperatureFeelsLike = data['main']['feels_like'].toString();
      final location = data['name'];
      return '$location \nТемпература: $temperature°C, (відчувається як $temperatureFeelsLike°C)\n$weather';
    } else {
      throw Exception('Помилка завантаження');
    }
  } catch (e) {
    return 'Виникла помилка: $e';
  }
}