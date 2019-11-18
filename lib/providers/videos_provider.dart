import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/video.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class VideosProvider with ChangeNotifier {
  int _quality = 50;
  int _size = 600;
  int _timeMs = 0;

  List<Video> _items = [];

  List<Video> get items {
    return [..._items];
  }

  Future<void> addVideo(
      String pickedVideoPath, File pickedThumbnail, VideoLocation videoLocation,
      [String pickedTitle = '']) async {
    final apiKey = await LocationHelper.getApiKey();
    final address = await LocationHelper.getPlaceAddress(
        videoLocation.latitude, videoLocation.longitude, apiKey);
    final updatedLocation = VideoLocation(
      latitude: videoLocation.latitude,
      longitude: videoLocation.longitude,
      address: address,
    );
    final newVideo = Video(
      id: DateTime.now().toString(),
      videoPath: pickedVideoPath,
      title: pickedTitle,
      location: updatedLocation,
      thumbnailPath: pickedThumbnail.path,
      thumbnail: pickedThumbnail,
    );
    print(pickedThumbnail.path);
    _items.add(newVideo);
    notifyListeners();
    DBHelper.insert('user_videos', {
      'id': newVideo.id,
      'title': newVideo.title,
      'thumbnailPath': newVideo.thumbnailPath,
      'videoPath': newVideo.videoPath,
      'loc_lat': newVideo.location.latitude,
      'loc_lng': newVideo.location.longitude,
      'address': newVideo.location.address,
    });
  }

  Future<File> getThumbnail(String videoPath) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: null,
        imageFormat: ImageFormat.JPEG,
        maxHeightOrWidth: _size,
        timeMs: _timeMs,
        quality: _quality);
    return File(thumbnail);
  }

  Future<void> fetchAndSetVideos() async {
    final dataList = await DBHelper.getData('user_videos');
    _items = dataList.reversed
        .map(
          (item) => Video(
            id: item['id'],
            title: item['title'],
            location: VideoLocation(
              latitude: item['loc_lat'],
              longitude: item['loc_lng'],
              address: item['address'],
            ),
            thumbnail: File(item['thumbnailPath']),
            thumbnailPath: item['thumbnailPath'],
            videoPath: item['videoPath'],
          ),
        )
        .toList();
    notifyListeners();
  }
}
