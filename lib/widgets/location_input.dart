import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'; // Need to add permission in the android manifest file to do anything with the location.
import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function selectPlace;

  LocationInput(this.selectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  Future<void> _getCurrentLocation() async {
    // Might want to do some error handling here, things can go south with .getLocation() 
    final locData = await Location().getLocation();
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage( // Function defined in location_helper.
      latitude: locData.latitude,
      longitude: locData.longitude,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
    widget.selectPlace(locData.latitude,locData.longitude);
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true, // Presents a 'X' instead of back arrow.
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    ); 
    // await => wait for the map_screen pop() to run and return to this page, and then complete the assignment to selectedLocation.
    // selectedLocation will store the value passed as an argument to pop() in the map_screen.
    // And that value is essentially a LatLng object containing the selected location's coordinates.
    
    if(selectedLocation == null) {
      return;
    } 
    // Is this a redundant check, already done in map_screen ?
    // No. Because, in map_screen, the button isn't activated till the user selects a place. 
    // But that doesn't guarentee against a null value being stored in selectedLocation due to the user exiting the map (using 'X') without touching any location

    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    ); // A professional thing to do would be to use a helper function here to avoid code duplication.
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
    widget.selectPlace(selectedLocation.latitude,selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          height: 175,
          width: double.infinity,
          child: _previewImageUrl == null
              ? Text(
                  'No location chosen yet',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Open in map'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
