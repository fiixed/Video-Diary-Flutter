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
  final _titleController = TextEditingController();
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  String _videoPath;
  VideoLocation _videoLocation;
  String _mood = 'One';

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
    _videoPath = ModalRoute.of(context).settings.arguments as String;
    _videoPlayerController = VideoPlayerController.file(File(_videoPath));

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 0.6666666666666666,
      autoPlay: true,
      looping: false,
      allowFullScreen: false,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _saveVideo() async {
    if (_videoPath == null || _videoLocation == null) {
      return;
    }
    File thumbnail = await Provider.of<VideosProvider>(context, listen: false)
        .getThumbnail(_videoPath);
    Provider.of<VideosProvider>(context, listen: false)
        .addVideo(_videoPath, thumbnail, _videoLocation, _mood);
    Navigator.of(context).pushReplacementNamed(VideosGridScreen.routeName);
  }

  void _selectLocation(double lat, double lng) async {
    final apiKey = await LocationHelper.getApiKey();
    _videoLocation = VideoLocation(latitude: lat, longitude: lng);
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
          title: Text('Add a New Video'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // TextField(
                //   decoration: InputDecoration(labelText: 'Title'),
                //   controller: _titleController,
                // ),
                MoodDropdownButton(_updateMood),
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
                RaisedButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text('Delete Video'),
                  elevation: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(VideoCaptureScreen.routeName);
                  },
                ),
                RaisedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Video'),
                  elevation: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  color: Theme.of(context).accentColor,
                  onPressed: _saveVideo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
