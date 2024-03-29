import 'dart:convert';

import 'package:http/http.dart' as http;

import './secret_loader.dart';



class LocationHelper {
 
   static Future<String> getApiKey() async {
    final Secret secret =  await SecretLoader(secretPath: 'secrets.json').load();
    return secret.apiKey;
    
  }

  static String generateLocationPreviewImage({double latitude, double longitude, String apiKey})  {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$apiKey';
  }

  static Future<String> getPlaceAddress(double lat, double lng, String apiKey) async {
    final String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';
    final http.Response response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }


}