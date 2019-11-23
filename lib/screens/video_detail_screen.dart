import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../providers/videos_provider.dart';
import '../models/video.dart';
import '../screens/map_screen.dart';

class VideoDetailScreen extends StatefulWidget {
  static const routeName = '/video-detail';

  @override
  _VideoDetailScreenState createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  Video selectedVideo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context).settings.arguments;
    selectedVideo =
        Provider.of<VideosProvider>(context, listen: false).findById(id);

    if (_videoPlayerController == null) {
      _videoPlayerController =
          VideoPlayerController.file(File(selectedVideo.videoPath));
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 0.6666666666666666,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
      );
    }
  }

  @override
  void dispose() {
    _videoPlayerController.pause();
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(selectedVideo.mood),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Chewie(
                          controller: _chewieController,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        selectedVideo.location.address,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FlatButton(
                        child: Text('View on Map'),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (ctx) => MapScreen(
                                locData: LocationData.fromMap({
                                  'latitude': selectedVideo.location.latitude,
                                  'longitude': selectedVideo.location.longitude,
                                }),
                                isSelecting: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
