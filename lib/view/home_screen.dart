// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_new_application/model/repo/news_repo.dart';
import 'package:weather_new_application/model/serializers/news_model.dart';
import 'package:weather_new_application/model/serializers/weather_data.dart';
import 'package:weather_new_application/view/common_widgets/calculation.dart';
import 'package:weather_new_application/view/common_widgets/custom_widgets.dart';
import 'package:weather_new_application/view/show_slider_widgets.dart';
import 'package:weather_new_application/view_model/weather_report_provider.dart';

import '../model/repo/weather_repo.dart';
import 'weather_daily_report.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _currentAddress;
  Position? _currentPosition;
  Forecast? forecast;
  WeatherData? weatherData;
  final timeIntervalWeatherData = [0, 8, 16, 24, 32];
  final WeatherRepository _weatherRepository = WeatherRepository();
  final NewApiRepo _newApiRepo = NewApiRepo();
  BuildContext? builderBuildContext;
  Size screenSize = Size.zero;
  bool isTempShownInCelsius = true;
  NewApiResultModel? newApiResultModel;
  String formattedDate = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocationProperties();
    });

    super.initState();
  }

  Future<void> getCurrentLocationProperties() async {
    await _getCurrentPosition().then(
      (value) async {
        weatherData = await _weatherRepository.getWeatherReport(
            Offset(_currentPosition!.latitude, _currentPosition!.longitude));
        forecast = await _weatherRepository.getForecaseReport(
            Offset(_currentPosition!.latitude, _currentPosition!.longitude));
        final DateTime currentDate = DateTime.now();
        final DateTime twoDaysAgo =
            currentDate.subtract(const Duration(days: 2));
        formattedDate =
            "${twoDaysAgo.year}-${twoDaysAgo.month.toString().padLeft(2, '0')}-${twoDaysAgo.day.toString().padLeft(2, '0')}";
        final String newCatagory = weatherData != null
            ? getArticleType(weatherData!.weather.first.main)
            : 'fear';
        newApiResultModel =
            await _newApiRepo.getArticle(newCatagory, formattedDate);
        Provider.of<UiStateChangeProvider>(builderBuildContext!, listen: false)
            .setCurrentWeather(forecast!, weatherData!);
        Provider.of<UiStateChangeProvider>(builderBuildContext!, listen: false)
            .setNewsArticle(newApiResultModel!);
      },
    );
  }

  String getArticleType(String weatherType) {
    switch (weatherType.toLowerCase()) {
      case 'rain':
        return 'joy';
      case 'clouds':
        return 'happiness';
      case 'sunny':
        return 'fear';
      default:
        return 'depression';
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider<UiStateChangeProvider>(
      create: (context) => UiStateChangeProvider(),
      child: Builder(builder: (context) {
        builderBuildContext = context;
        return Scaffold(
          appBar: AppBar(),
          body: getHomeScreenContent(),
          endDrawer: _getEndDrawer(),
        );
      }),
    );
  }

  Center getHomeScreenContent() {
    return Center(
      child: Consumer<UiStateChangeProvider>(
        builder:
            (BuildContext context, UiStateChangeProvider value, Widget? _) {
          weatherData = value.weatherDataProviderValue;
          forecast = value.forecastProviderValue;
          isTempShownInCelsius = value.isTempShownCelsiusProviderValue ?? true;
          newApiResultModel =
              value.newApiResultModelProviderValue ?? NewApiResultModel();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          _currentAddress ?? '',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                    getCacheImage(
                        (weatherData != null && weatherData!.weather.isNotEmpty)
                            ? weatherData!.weather.first.iconUrl
                            : ''),
                    (weatherData != null && weatherData!.weather.isNotEmpty)
                        ? Text(
                            weatherData!.weather.first.main,
                            style: Theme.of(context).textTheme.headlineMedium,
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                    Text(
                      (weatherData != null && weatherData!.weather.isNotEmpty)
                          ? 'L: ${isTempShownInCelsius ? Temperature.changeToCelsius(weatherData!.main.temp_min) : Temperature.changeToFarhenheit(weatherData!.main.temp_min)}° H: ${isTempShownInCelsius ? Temperature.changeToCelsius(weatherData!.main.temp_max) : Temperature.changeToFarhenheit(weatherData!.main.temp_max)}°'
                          : '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      (weatherData != null && weatherData!.weather.isNotEmpty)
                          ? weatherData!.weather.first.description
                          : '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    (forecast != null && forecast!.list.isNotEmpty)
                        ? WeatherDailyReport(
                            weatherData: [
                              for (int i in timeIntervalWeatherData)
                                forecast!.list[i].weather[0]
                            ],
                            dateTime: [
                              for (int i in timeIntervalWeatherData)
                                forecast!.list[i].dt_txt
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    (newApiResultModel != null &&
                            newApiResultModel!.articles != null &&
                            newApiResultModel!.articles!.isNotEmpty)
                        ? Flexible(
                            child: ShowSliderWidget(
                            newApiResultModel: newApiResultModel!,
                          ))
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getEndDrawer() {
    return SizedBox(
      width: screenSize.width * 0.6,
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 50),
          child: Column(
            children: [
              Consumer<UiStateChangeProvider>(
                builder: (BuildContext context, UiStateChangeProvider value,
                    Widget? child) {
                  isTempShownInCelsius =
                      value.isTempShownCelsiusProviderValue ?? true;
                  return Column(
                    children: [
                      _getTemperatureWidget(context),
                      const SizedBox(
                        height: 10,
                      ),
                      _getNewCategoryWidget(context)
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Row _getNewCategoryWidget(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'News Catagory',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GestureDetector(
                  onTap: () async {
                    buildNewArticle('joy');
                  },
                  child: Text(
                    'Joy',
                    style: Theme.of(context).textTheme.titleSmall,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GestureDetector(
                  onTap: () {
                    buildNewArticle('sports');
                  },
                  child: Text('Sports',
                      style: Theme.of(context).textTheme.titleSmall)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GestureDetector(
                  onTap: () {
                    buildNewArticle('business');
                  },
                  child: Text('Business',
                      style: Theme.of(context).textTheme.titleSmall)),
            ),
          ],
        )
      ],
    );
  }

  GestureDetector _getTemperatureWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<UiStateChangeProvider>(builderBuildContext!, listen: false)
            .alternateTempShownValue(isTempShownInCelsius);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Temperature',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            isTempShownInCelsius ? '°C' : '°F',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Future<void> buildNewArticle(String type) async {
    newApiResultModel = await _newApiRepo.getArticle(type, formattedDate);

    Provider.of<UiStateChangeProvider>(builderBuildContext!, listen: false)
        .setNewsArticle(newApiResultModel!);
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = place.locality;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
