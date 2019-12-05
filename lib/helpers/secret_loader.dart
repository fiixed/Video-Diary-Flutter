import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
class SecretLoader {
  SecretLoader({this.secretPath});
  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(secretPath,
        (String jsonStr) async {
      final Secret secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
  final String secretPath;
}

class Secret {
  Secret({this.apiKey = ''});
  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return Secret(apiKey: jsonMap['google_api_key']);
  }
  final String apiKey;
}