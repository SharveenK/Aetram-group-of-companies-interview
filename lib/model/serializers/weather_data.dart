// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:weather_new_application/model/serializers/serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
part 'weather_data.g.dart';

abstract class WeatherData implements Built<WeatherData, WeatherDataBuilder> {
  factory WeatherData(
          [Function(WeatherDataBuilder weatherDataBuilder) updates]) =
      _$WeatherData;
  WeatherData._();
  @BuiltValueField(wireName: 'weather')
  BuiltList<Weather> get weather;
  @BuiltValueField(wireName: 'main')
  MainData get main;

  static WeatherData fromJson(String jsonString) {
    return serializers.deserializeWith(
        WeatherData.serializer, json.decode(jsonString))!;
  }

  static Serializer<WeatherData> get serializer => _$weatherDataSerializer;
}

abstract class Weather implements Built<Weather, WeatherBuilder> {
  factory Weather([Function(WeatherBuilder weatherBuilder) updates]) =
      _$Weather;
  Weather._();
  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'main')
  String get main;
  @BuiltValueField(wireName: 'description')
  String get description;
  @BuiltValueField(wireName: 'icon')
  String get icon;
  String get iconUrl => "https://openweathermap.org/img/wn/$icon@2x.png";
  static Weather fromJson(String jsonString) {
    return serializers.deserializeWith(
        Weather.serializer, json.decode(jsonString))!;
  }

  static Serializer<Weather> get serializer => _$weatherSerializer;
}

abstract class Forecast implements Built<Forecast, ForecastBuilder> {
  factory Forecast([Function(ForecastBuilder forecastBuilder) updates]) =
      _$Forecast;
  Forecast._();
  @BuiltValueField(wireName: 'list')
  BuiltList<ListOfForeCast> get list;

  static Forecast fromJson(String jsonString) {
    return serializers.deserializeWith(
        Forecast.serializer, json.decode(jsonString))!;
  }

  static Serializer<Forecast> get serializer => _$forecastSerializer;
}

abstract class ListOfForeCast
    implements Built<ListOfForeCast, ListOfForeCastBuilder> {
  factory ListOfForeCast(
          [Function(ListOfForeCastBuilder listOfForeCastBuilder) updates]) =
      _$ListOfForeCast;
  ListOfForeCast._();
  @BuiltValueField(wireName: 'weather')
  BuiltList<Weather> get weather;
  @BuiltValueField(wireName: 'main')
  MainData get main;
  @BuiltValueField(wireName: 'dt_txt')
  String get dt_txt;

  static ListOfForeCast fromJson(String jsonString) {
    return serializers.deserializeWith(
        ListOfForeCast.serializer, json.decode(jsonString))!;
  }

  static Serializer<ListOfForeCast> get serializer =>
      _$listOfForeCastSerializer;
}

abstract class MainData implements Built<MainData, MainDataBuilder> {
  factory MainData([Function(MainDataBuilder mainDataBuilder) updates]) =
      _$MainData;
  MainData._();
  @BuiltValueField(wireName: 'temp')
  double get temp;
  @BuiltValueField(wireName: 'temp_min')
  double get temp_min;
  @BuiltValueField(wireName: 'temp_max')
  double get temp_max;

  static MainData fromJson(String jsonString) {
    return serializers.deserializeWith(
        MainData.serializer, json.decode(jsonString))!;
  }

  static Serializer<MainData> get serializer => _$mainDataSerializer;
}
