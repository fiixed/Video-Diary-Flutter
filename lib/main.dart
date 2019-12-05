import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

import './providers/videos_provider.dart';
import './screens/add_video_screen.dart';
import './screens/video_capture_screen.dart';
import './screens/video_detail_screen.dart';
import './screens/videos_grid_screen.dart';


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
    return ChangeNotifierProvider<VideosProvider>.value(
      value: VideosProvider(cameras),
      child: MaterialApp(
        title: 'Video Diary',
        theme: ThemeData.dark().copyWith(
          primaryColor: const Color(0xFF0A0E21),
          scaffoldBackgroundColor: const Color(0xFF0A0E21),
          accentColor: const Color.fromRGBO(218, 53, 88, 100),
          hoverColor: const Color.fromRGBO(218, 53, 88, 100),
          textTheme: TextTheme(
            title: const TextStyle(fontFamily: 'ModernMachine'),
            headline: TextStyle(fontFamily: 'Mollen', fontWeight: FontWeight.bold),
            body1: const TextStyle(fontFamily: 'Mollen'),
            button: const TextStyle(fontFamily: 'Mollen'),
          ),
        ),
        home: const VideosGridScreen(),
        routes: <String, Widget Function(BuildContext)>{
          AddVideoScreen.routeName: (BuildContext ctx) => AddVideoScreen(),
          VideoCaptureScreen.routeName: (BuildContext ctx) => VideoCaptureScreen(),
          VideosGridScreen.routeName: (BuildContext ctx) => const VideosGridScreen(),
          VideoDetailScreen.routeName: (BuildContext ctx) => VideoDetailScreen(),
        },
        
      ),
     
    );
  }
}
