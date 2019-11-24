import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './video_capture_screen.dart';
import '../providers/videos_provider.dart';
import '../screens/video_detail_screen.dart';

class VideosGridScreen extends StatelessWidget {
  static const routeName = '/videos-grid-screen';

  const VideosGridScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    final double widthScreen = mediaQueryData.size.width;
    final double appBarHeight = kToolbarHeight;
    final double paddingBottom = mediaQueryData.padding.bottom;
    final double heightScreen =
        mediaQueryData.size.height - paddingBottom - appBarHeight;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('VIDEO DIARY'),
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
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<VideosProvider>(
                    child: Center(
                      child: Text(
                        'Got no videos yet, start creating some!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    builder: (ctx, videosProvider, ch) =>
                        videosProvider.items.length <= 0
                            ? ch
                            : GridView.builder(
                                itemCount: videosProvider.items.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio:
                                            widthScreen / heightScreen + 0.15,
                                        crossAxisCount: 2),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          VideoDetailScreen.routeName,
                                          arguments:
                                              videosProvider.items[index].id);
                                    },
                                    child: GridTile(
                                      footer: GridTileBar(
                                        backgroundColor: Colors.black45,
                                        title: _GridTitleText( 
                                            videosProvider.items[index].mood),
                                        subtitle: _GridTitleText(videosProvider
                                            .items[index].location.address),
                                        // trailing: Icon(
                                        //   icon,
                                        //   color: Colors.white,
                                        // ),
                                      ),
                                      child: Image.file(
                                        videosProvider.items[index].thumbnail,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                  // return GestureDetector(

                                  // child: GridTile(
                                  //   header: Text(
                                  //       videosProvider.items[index].location.address),
                                  //       footer: ,
                                  //   child: Image.file(
                                  //       videosProvider.items[index].thumbnail),
                                  // ),
                                  // onTap: () {
                                  //   Navigator.of(context).pushNamed(
                                  //       VideoDetailScreen.routeName,
                                  //       arguments: videosProvider.items[index].id);
                                  // },
                                  // );
                                },
                              ),
                  ),
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
