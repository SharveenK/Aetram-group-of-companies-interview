import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:weather_new_application/model/serializers/serializers.dart';
part 'news_model.g.dart';

abstract class NewApiResultModel
    implements Built<NewApiResultModel, NewApiResultModelBuilder> {
  factory NewApiResultModel(
      [Function(NewApiResultModelBuilder newApiResultModelBuilder)
          updates]) = _$NewApiResultModel;
  NewApiResultModel._();
  @BuiltValueField(wireName: 'articles')
  BuiltList<NewsApi?>? get articles;

  static NewApiResultModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        NewApiResultModel.serializer, json.decode(jsonString))!;
  }

  static Serializer<NewApiResultModel> get serializer =>
      _$newApiResultModelSerializer;
}

abstract class NewsApi implements Built<NewsApi, NewsApiBuilder> {
  factory NewsApi([Function(NewsApiBuilder newsApiBuilder) updates]) =
      _$NewsApi;
  NewsApi._();
  @BuiltValueField(wireName: 'author')
  String? get author;
  @BuiltValueField(wireName: 'title')
  String? get title;
  @BuiltValueField(wireName: 'description')
  String? get description;
  @BuiltValueField(wireName: 'url')
  String? get urlToArticle;
  @BuiltValueField(wireName: 'urlToImage')
  String? get urlToImage;
  @BuiltValueField(wireName: 'publishedAt')
  String? get publishedAt;
  @BuiltValueField(wireName: 'content')
  String? get content;

  static NewsApi fromJson(String jsonString) {
    return serializers.deserializeWith(
        NewsApi.serializer, json.decode(jsonString))!;
  }

  static Serializer<NewsApi> get serializer => _$newsApiSerializer;
}
