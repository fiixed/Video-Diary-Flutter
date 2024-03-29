import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  const LocationInput(this.onSelectLocation);

  final Function onSelectLocation;

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;
  String _apiKey;

  @override
  void initState() {
    super.initState();
    _getCurrentUserLocation();
  }

  Future<void> _showPreview(double lat, double lng) async {
    _apiKey = await LocationHelper.getApiKey();
    final String staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
      apiKey: _apiKey,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final LocationData locData = await Location().getLocation();
      _apiKey = await LocationHelper.getApiKey();
      _showPreview(locData.latitude, locData.longitude);
      widget.onSelectLocation(locData.latitude, locData.longitude);
    } catch (e) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final LocationData locData = await Location().getLocation();
    final LatLng selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute<LatLng>(
        fullscreenDialog: true,
        builder: (BuildContext ctx) => MapScreen(
          locData: locData,
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectLocation(
        selectedLocation.latitude, selectedLocation.longitude);
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
              ? const Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        // Row(
        //   children: <Widget>[
            // FlatButton.icon(
            //   icon: Icon(Icons.location_on),
            //   label: Text('Current Location'),
            //   textColor: Theme.of(context).primaryColor,
            //   onPressed: _getCurrentUserLocation,
            // ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: const Text('Select on Map'),
              onPressed: _selectOnMap,
            ),
        //   ],
        // ),
      ],
    );
  }
}
