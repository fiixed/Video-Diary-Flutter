import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:camera/camera.dart' as cam;

import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

import '../models/video.dart';



class VideosProvider with ChangeNotifier {
  
  VideosProvider(this._cameras);

  final int _quality = 50;
  final int _size = 600;
  final int _timeMs = 5;

  List<Video> _items = <Video>[];
  List<cam.CameraDescription> _cameras;

  List<Video> get items {
    return <Video>[..._items];
  }

  List<cam.CameraDescription> get cams {
    return <cam.CameraDescription>[..._cameras];
  }

  set cameras(List<cam.CameraDescription> cams) {
    _cameras = cams;
  }

  Video findById(String id) {
    return _items.firstWhere((Video video) => video.id == id);
  }

  String getDate(String id) {
    final Video pickedVideo = _items.firstWhere((Video video) => video.id == id, orElse: () => _items[0]);
    return DateFormat.yMEd().add_jms().format(DateTime.parse(pickedVideo.id)) ;
  }

  Future<void> addVideo(
      String pickedVideoPath, File pickedThumbnail, VideoLocation videoLocation,
      String pickedMood) async {
    final String apiKey = await LocationHelper.getApiKey();
    final String address = await LocationHelper.getPlaceAddress(
        videoLocation.latitude, videoLocation.longitude, apiKey);
    final VideoLocation updatedLocation = VideoLocation(
      latitude: videoLocation.latitude,
      longitude: videoLocation.longitude,
      address: address,
    );
    final Video newVideo = Video(
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
    DBHelper.insert('user_videos', <String, dynamic>{
      'id': newVideo.id,
      'mood': newVideo.mood,
      'thumbnailPath': newVideo.thumbnailPath,
      'videoPath': newVideo.videoPath,
      'loc_lat': newVideo.location.latitude,
      'loc_lng': newVideo.location.longitude,
      'address': newVideo.location.address,
    });
  }

  void deleteVideo(String id) {
    _items.removeWhere((Video video) => video.id == id);
     notifyListeners();
     DBHelper.delete(id);
  }

  Future<File> getThumbnail(String videoPath) async {
    final String thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: null,
        imageFormat: ImageFormat.PNG,
        maxHeightOrWidth: _size,
        timeMs: _timeMs,
        quality: _quality);
    return File(thumbnail);
  }

  Future<void> fetchAndSetVideos() async {
    final List<Map<String, dynamic>> dataList = await DBHelper.getData('user_videos');
    _items = dataList.reversed
        .map(
          (Map<String, dynamic>item) => Video(
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
