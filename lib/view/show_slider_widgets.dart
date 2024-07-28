import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:weather_new_application/model/serializers/news_model.dart';
import 'package:weather_new_application/view/common_widgets/custom_widgets.dart';
import 'package:weather_new_application/view/news_overview_page.dart';

// ignore: must_be_immutable
class ShowSliderWidget extends StatelessWidget {
  ShowSliderWidget({super.key, required this.newApiResultModel});
  final NewApiResultModel newApiResultModel;
  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    for (var newsArticle in newApiResultModel.articles!) {
      if (newsArticle != null &&
          newsArticle.content != null &&
          newsArticle.description != null &&
          newsArticle.title != null &&
          newsArticle.urlToImage != null &&
          newsArticle.urlToArticle != null) {
        Widget widget = getSlidingWidgets(context, newsArticle);
        items.add(widget);
      }
      if (items.length > 10) {
        break;
      }
    }
    return CarouselSlider(
      carouselController: carouselController,
      items: items,
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.4,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 1,
      ),
    );
  }

  Widget getSlidingWidgets(BuildContext context, NewsApi newsArticle) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewOverviewPage(newsArticle: newsArticle),
            ));
      },
      child: Card(
        child: ClipRRect(
          child: SizedBox(
              height: 316,
              child: Column(
                children: [
                  getCacheImage(newsArticle.urlToImage!),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      newsArticle.title!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: Text(
                      newsArticle.content!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(overflow: TextOverflow.ellipsis),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
