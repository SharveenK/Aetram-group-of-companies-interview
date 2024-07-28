import 'package:http/http.dart' as http;
import 'package:http_client_helper/http_client_helper.dart';

class ApiProvider {
  static String openWeatherApiKey = 'e900536a0f104c57115f8467cbc74ef3';
  static String weatherReportBaseUrl =
      'https://api.openweathermap.org/data/2.5/';

  Future<String> getWeatherReport(String url) async {
    final http.Response? response = await HttpClientHelper.get(
        Uri.parse('$weatherReportBaseUrl$url$openWeatherApiKey'));

    return response != null ? response.body : '';
  }

  Future<String> getNewsArticle(String url) async {
    final http.Response? response = await HttpClientHelper.get(Uri.parse(url));

    return response != null ? response.body : '';
  }
}
