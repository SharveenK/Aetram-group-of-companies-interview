import 'package:weather_new_application/model/api_providers.dart';
import 'package:weather_new_application/model/serializers/news_model.dart';

class NewApiRepo {
  static String newsApiKey = 'cf7aedf482064c4cab6c06fb427e7c14';
  String baseUrl = 'https://newsapi.org/v2/everything?';

  ApiProvider apiProvider = ApiProvider();
  Future<NewApiResultModel> getArticle(
      String articleRelatedTo, String fromDate) async {
    String url = '$baseUrl'
        'q=$articleRelatedTo&from=$fromDate&sortBy=popularity&apiKey=$newsApiKey';
    String response = await apiProvider.getNewsArticle(url);
    NewApiResultModel newApiResultModel = NewApiResultModel.fromJson(response);
    return newApiResultModel;
  }
}
