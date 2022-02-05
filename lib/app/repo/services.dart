import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_blog/app/model/weather_model.dart';

class DataService {
  Future<WeatherResponse> getWeather(String city) async {

    final queryParameters = {
      'q': city,
      'appid': 'bb9f08eb4345ea71f87bef7445d3f7df',
      'units': 'imperial'
    };

    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);

    final response = await http.get(uri);

    print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}