import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../providers/videos_provider.dart';
import '../models/video.dart';
import '../screens/map_screen.dart';
import '../screens/videos_grid_screen.dart';

class VideoDetailScreen extends StatefulWidget {
  static const routeName = '/video-detail';

  @override
  _VideoDetailScreenState createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  Video selectedVideo;
  VideosProvider videosProvider;
  String videoDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context).settings.arguments;
    videosProvider = Provider.of<VideosProvider>(context, listen: false);
    selectedVideo = videosProvider.findById(id);
    videoDate = Provider.of<VideosProvider>(context, listen: false)
        .getDate(selectedVideo.id);

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
          title: Text(
            videoDate,
            style: Theme.of(context).textTheme.title,
          ),
          centerTitle: true,
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
                        selectedVideo.mood,
                        style: TextStyle(
                          fontSize: 40,
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
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            RaisedButton.icon(
              icon: Icon(Icons.delete),
              label: Text('Delete Video'),
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).accentColor,
              onPressed: () async {
                await videosProvider.deleteVideo(selectedVideo.id);
                Navigator.of(context)
                    .pushReplacementNamed(VideosGridScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
