import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/videos_provider.dart';
import '../screens/video_detail_screen.dart';
import './video_capture_screen.dart';


class VideosGridScreen extends StatelessWidget {

  const VideosGridScreen({Key key}) : super(key: key);

  static const String routeName = '/videos-grid-screen';

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double widthScreen = mediaQueryData.size.width;
    final double appBarHeight = kToolbarHeight;
    final double paddingBottom = mediaQueryData.padding.bottom;
    final double heightScreen =
        mediaQueryData.size.height - paddingBottom - appBarHeight;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          'VIDEO DIARY',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(VideoCaptureScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: Provider.of<VideosProvider>(context, listen: false)
            .fetchAndSetVideos(),
        builder: (BuildContext ctx, AsyncSnapshot<void> snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: const CircularProgressIndicator(),
              )
            : Consumer<VideosProvider>(
                child: Center(
                  child: Text(
                    'Got no videos yet, start creating some!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                builder: (BuildContext ctx, VideosProvider videosProvider, Widget ch) => videosProvider
                            .items.isEmpty
                    ? ch
                    : GridView.builder(
                        itemCount: videosProvider.items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: widthScreen / heightScreen + 0.15,
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  VideoDetailScreen.routeName,
                                  arguments: videosProvider.items[index].id);
                            },
                            child: GridTile(
                              footer: GridTileBar(
                                backgroundColor: Colors.black45,
                                title: _GridTitleText(videosProvider
                                    .getDate(videosProvider.items[index].id)),
                                subtitle: _GridTitleText(
                                  videosProvider.items[index].mood,
                                ),
                              ),
                              child: Image.file(
                                File(videosProvider.items[index].thumbnailPath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(VideoCaptureScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(text),
    );
  }
}
