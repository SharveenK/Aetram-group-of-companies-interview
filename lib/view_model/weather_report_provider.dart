import 'package:flutter/material.dart';
import 'package:weather_new_application/model/serializers/news_model.dart';
import 'package:weather_new_application/model/serializers/weather_data.dart';

class UiStateChangeProvider with ChangeNotifier {
  Forecast? forecastProviderValue;
  WeatherData? weatherDataProviderValue;
  bool? isTempShownCelsiusProviderValue;
  NewApiResultModel? newApiResultModelProviderValue;
  void setCurrentWeather(Forecast forecast, WeatherData weatherData) {
    forecastProviderValue = forecast;
    weatherDataProviderValue = weatherData;
    notifyListeners();
  }

  void alternateTempShownValue(bool isShownInCelcius) {
    isTempShownCelsiusProviderValue = !isShownInCelcius;
    notifyListeners();
  }

  void setNewsArticle(NewApiResultModel newsApiResults) {
    newApiResultModelProviderValue = newsApiResults;
    notifyListeners();
  }
}
