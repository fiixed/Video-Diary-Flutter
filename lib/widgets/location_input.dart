import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectLocation;
  LocationInput(this.onSelectLocation);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    final apiKey = await LocationHelper.getApiKey();

    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: locData.latitude,
      longitude: locData.longitude,
      apiKey: apiKey,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
    widget.onSelectLocation(locData.latitude, locData.longitude);
  }

  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          locData: locData,
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }

    widget.onSelectLocation(selectedLocation.latitude, selectedLocation.longitude);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _selectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
