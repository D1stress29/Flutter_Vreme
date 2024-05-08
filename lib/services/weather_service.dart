import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_vreme/models/weather_model.dart';

class WeatherService {

final String apiKey;
static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
WeatherService(this.apiKey);

Future<Weather> getWeather(String cityName) async {
  final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

  if (response.statusCode == 200) {
    return Weather.fromJson(jsonDecode(response.body));
  } else {
    String errorMessage = 'Failed to load weather data. Status Code: ${response.statusCode}';
  
  if (response.body != null && response.body.isNotEmpty) {
    // Include response body in the error message if available
    errorMessage += ', Response Body: ${response.body}';
  }
  
  throw Exception(errorMessage);
}
}

Future<String> getCurrentCity() async {
  try {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Handle denied permission or provide fallback behavior
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks.isNotEmpty ? placemarks[0].locality : null;
    return city ?? "City not found";
  } catch (e) {
    // Create an error message and return it
    String errorMessage = "Error getting current city: $e";
    return errorMessage;
  }
}
}