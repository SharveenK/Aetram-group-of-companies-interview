import 'package:flutter/material.dart';
import 'package:weather_new_application/model/api_providers.dart';
import 'package:weather_new_application/model/serializers/weather_data.dart';

class WeatherRepository {
  ApiProvider apiProvider = ApiProvider();
  Future<WeatherData> getWeatherReport(Offset latAndLong) async {
    String url = 'weather?lat=${latAndLong.dx}&lon=${latAndLong.dy}&appid=';
    String response = await apiProvider.getWeatherReport(url);
    WeatherData weatherData = WeatherData.fromJson(response);
    return weatherData;
  }

  Future<Forecast> getForecaseReport(Offset latAndLong) async {
    String url = 'forecast?lat=${latAndLong.dx}&lon=${latAndLong.dy}&appid=';
    String response = await apiProvider.getWeatherReport(url);
    Forecast forecast = Forecast.fromJson(response);
    return forecast;
  }
}
