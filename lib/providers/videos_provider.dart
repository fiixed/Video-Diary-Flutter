import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/video.dart';
import '../helpers/db_helper.dart';

class VideosProvider with ChangeNotifier {
  int _quality = 50;
  int _size = 600;
  int _timeMs = 0;

  List<Video> _items = [];

  List<Video> get items {
    return [..._items];
  }

  void addVideo(String pickedVideoPath, File pickedThumbnail,
      [String pickedTitle = '']) {
    final newVideo = Video(
      id: DateTime.now().toString(),
      videoPath: pickedVideoPath,
      title: pickedTitle,
      location: null,
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
    print(dataList);
    _items = dataList
        .map(
          (item) => Video(
                id: item['id'],
                title: item['title'],
                location: null, 
                thumbnail: File(item['thumbnailPath']), 
                thumbnailPath: item['thumbnailPath'], 
                videoPath: item['videoPath'],
              ),
        )
        .toList();
    notifyListeners();
        

    
  }
}
