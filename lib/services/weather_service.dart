import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/weather.dart';

class WeatherService {
  Future<Weather> getWeather(String city) async {
    if (openWeatherApiKey == 'YOUR_OPENWEATHER_API_KEY') {
      throw Exception(
        'Bạn chưa cấu hình OpenWeatherMap API key trong lib/config.dart.',
      );
    }

    final uri = Uri.parse(openWeatherBaseUrl).replace(
      queryParameters: {
        'q': city,
        'appid': openWeatherApiKey,
        'units': 'metric',
        'lang': 'vi',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 401) {
      throw Exception('API key không hợp lệ hoặc chưa được kích hoạt.');
    }

    if (response.statusCode == 404) {
      throw Exception('Không tìm thấy thành phố "$city".');
    }

    throw Exception(
      'Không thể lấy dữ liệu thời tiết. Mã lỗi: ${response.statusCode}',
    );
  }
}
