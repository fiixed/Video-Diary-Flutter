import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart' as cam;

import '../models/video.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class VideosProvider with ChangeNotifier {
  int _quality = 50;
  int _size = 600;
  int _timeMs = 5;

  List<Video> _items = [];
  List<cam.CameraDescription> _cameras;

  VideosProvider(this._cameras);

  List<Video> get items {
    return [..._items];
  }

  List<cam.CameraDescription> get cams {
    return [..._cameras];
  }

  void set cameras(List<cam.CameraDescription> cams) {
    _cameras = cams;
  }

  Video findById(String id) {
    return _items.firstWhere((video) => video.id == id);
  }

  String getDate(String id) {
    Video pickedVideo = _items.firstWhere((video) => video.id == id, orElse: () => _items[0]);
    return DateFormat.yMEd().add_jms().format(DateTime.parse(pickedVideo.id)) ;
  }

  Future<void> addVideo(
      String pickedVideoPath, File pickedThumbnail, VideoLocation videoLocation,
      String pickedMood) async {
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
      mood: pickedMood,
      location: updatedLocation,
      thumbnailPath: pickedThumbnail.path,
      thumbnail: pickedThumbnail,
    );
    print(pickedThumbnail.path);
    _items.insert(0, newVideo);
    notifyListeners();
    DBHelper.insert('user_videos', {
      'id': newVideo.id,
      'mood': newVideo.mood,
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
        imageFormat: ImageFormat.PNG,
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
            mood: item['mood'],
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
