import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_new_application/model/serializers/weather_data.dart';
import 'package:weather_new_application/view/common_widgets/custom_widgets.dart';

// ignore: must_be_immutable
class WeatherDailyReport extends StatelessWidget {
  WeatherDailyReport(
      {super.key, required this.weatherData, required this.dateTime});
  final List<Weather> weatherData;
  final List<String> dateTime;
  Size screenSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 1.0, right: 1),
      child: Wrap(
        children: List.generate(
          weatherData.length,
          (index) {
            final inputFormat = DateFormat('yyyy-MM-dd HH:mm');
            final inputDate = inputFormat.parse(dateTime[index]);

            final outputFormat = DateFormat('dd/MM');
            final formattedDate = outputFormat.format(inputDate);
            return SizedBox(
              width: screenSize.width * 0.18,
              child: Column(
                children: [
                  getCacheImage(weatherData[index].iconUrl),
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    weatherData[index].main,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
