import 'dart:io';

import 'package:flutter/foundation.dart';

class VideoLocation {
  final double latitude;
  final double longitude;
  final String address;

  VideoLocation({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });
}

class Video {
  final String id;
  final String title;
  final VideoLocation location;
  final String videoPath;
  final String thumbnailPath;
  final File thumbnail;

  Video({
    @required this.id,
    this.title,
    @required this.location,
    @required this.videoPath,
    @required this.thumbnailPath,
    @required this.thumbnail,
  });
}
