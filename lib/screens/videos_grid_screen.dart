import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './video_capture_screen.dart';
import '../providers/videos_provider.dart';

class VideosGridScreen extends StatelessWidget {
  static const routeName = '/videos-grid-screen';

  const VideosGridScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: Container(),
        title: Text('Your Videos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(VideoCaptureScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<VideosProvider>(context, listen: false)
            .fetchAndSetVideos(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<VideosProvider>(
                child: Center(
                  child: Text('Got no videos yet, start creating some!'),
                ),
                builder: (ctx, videosProvider, ch) =>
                    videosProvider.items.length <= 0
                        ? ch
                        : GridView.builder(
                            itemCount: videosProvider.items.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return GridTile(
                                child: Container(
                                  child: Image.file(
                                      videosProvider.items[index].thumbnail),
                                  color: Colors.black87,
                                ),
                              );
                            },
                          ),
              ),
      ),
    );
  }
}
