import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/video.dart';

class MapScreen extends StatefulWidget {
  //final VideoLocation initialLocation;
  final LocationData locData;
  final bool isSelecting;

  MapScreen({this.locData, this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map', style: Theme.of(context).textTheme.title,),
        centerTitle: true,
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.locData.latitude,
            widget.locData.longitude,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedLocation == null && widget.isSelecting)
            ? null
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(
                        widget.locData.latitude,
                        widget.locData.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
