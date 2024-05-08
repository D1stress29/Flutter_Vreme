import 'package:flutter/material.dart';
import 'package:flutter_vreme/models/weather_model.dart';
import 'package:lottie/lottie.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}
class _WeatherPageState extends State<WeatherPage> {
  
  final _weatherService = WeatherService('255f268d2129ee2e7ad58a217925cb01');
  Weather? _weather;


  _fetchWeather() async {
    try{
    String cityName = await _weatherService.getCurrentCity();

    
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch(e){
      print(e);
    }
  }


String getWeatherAnimation(String mainCondition) {


switch(mainCondition.toLowerCase()) {
  case 'clouds':
  case 'mist':
  case 'smoke':
  case 'haze':
  case 'dust':
  case 'fog':
    return 'assets/Cloudy.json';
  case 'rain':
  case 'drizzle':
  return 'assets/Rainy.json';
  case 'thunderstorm':
    return 'assets/Stormy.json';
    default:
    return 'assets/Sunny.json';
}
}
@override
void initState() {
super.initState();

_fetchWeather();
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_weather?.cityName ?? "loading city..."),

Lottie.asset(getWeatherAnimation(_weather?.mainCondition ?? '')),

        Text('${_weather?.temperature.round()}"C'),
        ],
      ),
    ),
  );
   }
}
 
