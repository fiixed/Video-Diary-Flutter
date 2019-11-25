import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

import './providers/videos_provider.dart';
import './screens/videos_grid_screen.dart';
import './screens/add_video_screen.dart';
import './screens/video_capture_screen.dart';
import './screens/video_detail_screen.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: VideosProvider(),
      child: MaterialApp(
        title: 'Video Diary',
        theme: ThemeData.dark().copyWith(
          primaryColor: Color(0xFF0A0E21),
          scaffoldBackgroundColor: Color(0xFF0A0E21),
          accentColor: Colors.green,
          textTheme: TextTheme(
            title: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
          ),
        ),
        home: VideosGridScreen(),
        routes: {
          AddVideoScreen.routeName: (ctx) => AddVideoScreen(),
          VideoCaptureScreen.routeName: (ctx) => VideoCaptureScreen(cameras),
          VideosGridScreen.routeName: (ctx) => VideosGridScreen(),
          VideoDetailScreen.routeName: (ctx) => VideoDetailScreen(),
        },
      ),
    );
  }
}
