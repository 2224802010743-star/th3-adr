import 'package:flutter/material.dart';
import '../models/weather.dart';

class WeatherDetailScreen extends StatelessWidget {
  final Weather weather;

  const WeatherDetailScreen({
    super.key,
    required this.weather,
  });

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết thời tiết'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          _buildMainWeather(context),
          const SizedBox(height: 18),
          const Text(
            'Thông tin chi tiết',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.55,
            children: [
              _infoCard(Icons.thermostat, 'Cảm giác như',
                  '${weather.feelsLike.toStringAsFixed(1)} °C'),
              _infoCard(Icons.water_drop, 'Độ ẩm', '${weather.humidity}%'),
              _infoCard(Icons.air, 'Tốc độ gió',
                  '${weather.windSpeed.toStringAsFixed(1)} m/s'),
              _infoCard(Icons.speed, 'Áp suất', '${weather.pressure} hPa'),
              _infoCard(Icons.visibility, 'Tầm nhìn',
                  '${(weather.visibility / 1000).toStringAsFixed(1)} km'),
              _infoCard(Icons.thermostat_auto, 'Min / Max',
                  '${weather.tempMin.toStringAsFixed(1)} / ${weather.tempMax.toStringAsFixed(1)} °C'),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Dữ liệu được cung cấp bởi OpenWeatherMap.',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainWeather(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            '${weather.cityName}, ${weather.country}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.network(
            weather.iconUrl,
            width: 95,
            height: 95,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.cloud, size: 80, color: Colors.white),
          ),
          Text(
            '${weather.temperature.toStringAsFixed(1)}°C',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            _capitalize(weather.description),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhiệt độ: ${weather.tempMin.toStringAsFixed(1)}°C – ${weather.tempMax.toStringAsFixed(1)}°C',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 27),
            const SizedBox(height: 7),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
