library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

import 'package:built_value/standard_json_plugin.dart';
import 'package:weather_new_application/model/serializers/news_model.dart';
import 'weather_data.dart';

part 'serializers.g.dart';

@SerializersFor(<Type>[
  WeatherData,
  Weather,
  ListOfForeCast,
  Forecast,
  MainData,
  NewApiResultModel,
  NewsApi
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

T deserialize<T>(dynamic value) => serializers.deserializeWith<T>(
    serializers.serializerForType(T)! as Serializer<T>, value) as T;

BuiltList<T> deserializeListof<T>(dynamic value) => BuiltList.from(
    value.map((value) => deserialize<T>(value)).toList(growable: false));
