import './secret_loader.dart';

class LocationHelper {
   
   static Future<String> getApiKey() async {
    Secret secret =  await SecretLoader(secretPath: "secrets.json").load();
    return secret.apiKey;
    
  }

  static String generateLocationPreviewImage({double latitude, double longitude, String apiKey})  {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$apiKey';
  }


}