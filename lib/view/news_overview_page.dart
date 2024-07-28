// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_new_application/model/serializers/news_model.dart';
import 'package:weather_new_application/view/common_widgets/custom_widgets.dart';

class NewOverviewPage extends StatelessWidget {
  NewOverviewPage({super.key, required this.newsArticle});
  final NewsApi newsArticle;
  Size screenSize = Size.zero;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('New overview',
            style: Theme.of(context).textTheme.titleLarge!),
      ),
      body: _getNewsOverviewContent(context),
    );
  }

  Widget _getNewsOverviewContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenSize.height * 0.3,
              child: getCacheImage(newsArticle.urlToImage!),
            ),
            Text('Title : ${newsArticle.title}',
                style: Theme.of(context).textTheme.titleMedium!),
            const SizedBox(
              height: 10,
            ),
            Text('Description : ${newsArticle.title}',
                style: Theme.of(context).textTheme.titleSmall!),
            const SizedBox(
              height: 10,
            ),
            Text('Content : ${newsArticle.content}',
                style: Theme.of(context).textTheme.titleSmall!),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                _launchInWebView(Uri.parse(newsArticle.urlToArticle!));
              },
              child: Text('url to article : ${newsArticle.urlToArticle}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.blue)),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }
}
