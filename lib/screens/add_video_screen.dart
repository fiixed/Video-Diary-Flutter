import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../models/video.dart';
import '../providers/videos_provider.dart';
import '../screens/video_capture_screen.dart';
import '../screens/videos_grid_screen.dart';
import '../widgets/location_input.dart';
import '../widgets/mood_dropdown_button.dart';


class AddVideoScreen extends StatefulWidget {
  static const String routeName = '/add-video';
  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  String _videoPath;
  VideoLocation _videoLocation;
  String _mood = '😀';
  bool _previewLoaded = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_videoPlayerController == null) {
      _videoPath = ModalRoute.of(context).settings.arguments as String;
      _videoPlayerController = VideoPlayerController.file(File(_videoPath));

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
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> _saveVideo() async {
    if (_videoPath == null ||
        _videoLocation == null ||
        _previewLoaded == false) {
      return;
    }

    final File _thumbnail = await Provider.of<VideosProvider>(context, listen: false)
        .getThumbnail(_videoPath);

    Provider.of<VideosProvider>(context, listen: false)
        .addVideo(_videoPath, _thumbnail, _videoLocation, _mood);
    Navigator.of(context).pushNamed(VideosGridScreen.routeName);
  }

  void _selectLocation(double lat, double lng) {
    _videoLocation = VideoLocation(latitude: lat, longitude: lng);
    setState(() {
      _previewLoaded = true;
    });
  }

  void _updateMood(String text) {
    setState(() {
      _mood = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text(
            'Add a New Video',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Mood',
                            style: Theme.of(context).textTheme.headline,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          MoodDropdownButton(_updateMood),
                        ],
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: Chewie(
                          controller: _chewieController,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      LocationInput(_selectLocation),
                    ],
                  ),
                ),
              ),
            ),
            RaisedButton.icon(
              icon: Icon(Icons.delete),
              label: const Text('Delete Video'),
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).accentColor,
              onPressed: () {
                if (_previewLoaded == false || _videoPath == null) {
                  return;
                }
                final File file = File(_videoPath);
                if (file.existsSync()) {
                  file.delete();
                }
                Navigator.of(context)
                    .pushReplacementNamed(VideoCaptureScreen.routeName);
              },
            ),
            RaisedButton.icon(
              icon: Icon(Icons.add),
              label: const Text('Add Video'),
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).toggleableActiveColor,
              textColor: const Color(0xFF0A0E21),
              onPressed: _saveVideo,
            ),
          ],
        ),
      ),
    );
  }
}
