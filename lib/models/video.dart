import 'dart:io';

import 'package:flutter/foundation.dart';

class VideoLocation {
  const VideoLocation({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

class Video {
  Video({
    @required this.id,
    @required this.mood,
    @required this.location,
    @required this.videoPath,
    @required this.thumbnailPath,
    @required this.thumbnail,
  });

  final String id;
  final String mood;
  final VideoLocation location;
  final String videoPath;
  final String thumbnailPath;
  final File thumbnail;
}
