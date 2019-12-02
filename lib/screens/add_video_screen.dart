import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../screens/video_capture_screen.dart';
import '../screens/videos_grid_screen.dart';
import '../providers/videos_provider.dart';
import '../widgets/location_input.dart';
import '../helpers/location_helper.dart';
import '../widgets/mood_dropdown_button.dart';
import '../models/video.dart';

class AddVideoScreen extends StatefulWidget {
  static const routeName = '/add-video';
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
  void initState() {
    super.initState();
    // _videoPlayerController = VideoPlayerController.file(File(_videoPath));

    // _chewieController = ChewieController(
    //   videoPlayerController: _videoPlayerController,
    //   aspectRatio: 2 / 3,
    //   autoPlay: true,
    //   looping: true,
    //   allowFullScreen: false,
    // );
  }

  @override
  void didChangeDependencies() {
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

    File _thumbnail = await Provider.of<VideosProvider>(context, listen: false)
        .getThumbnail(_videoPath);

    Provider.of<VideosProvider>(context, listen: false)
        .addVideo(_videoPath, _thumbnail, _videoLocation, _mood);
    Navigator.of(context).pushNamed(VideosGridScreen.routeName);
  }

  void _selectLocation(double lat, double lng) async {
    _videoLocation = VideoLocation(latitude: lat, longitude: lng);
    setState(() {
      _previewLoaded = true;
    });
  }

  _updateMood(String text) {
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
                      // TextField(
                      //   decoration: InputDecoration(labelText: 'Title'),
                      //   controller: _titleController,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Mood',
                            style: Theme.of(context).textTheme.headline,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          MoodDropdownButton(_updateMood),
                        ],
                      ),

                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: Chewie(
                          controller: _chewieController,
                        ),
                      ),
                      SizedBox(
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
              label: Text('Delete Video'),
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).accentColor,
              onPressed: () {
                if (_previewLoaded == false || _videoPath == null) {
                  return;
                }
                File file = new File(_videoPath);
                if (file.existsSync()) {
                  file.delete();
                }
                Navigator.of(context)
                    .pushReplacementNamed(VideoCaptureScreen.routeName);
              },
            ),
            RaisedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add Video'),
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).toggleableActiveColor,
              textColor: Color(0xFF0A0E21),
              onPressed: _saveVideo,
            ),
          ],
        ),
      ),
    );
  }
}
