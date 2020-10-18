import 'package:http/http.dart' as http;
import 'dart:convert';

// The file which handles all the calls to the google API
const GOOGLE_API_KEY = 'AIzaSyBaxI0PeeLJSq-NRFofau6PNm9Z1zsham4';

class LocationHelper {
  static String generateLocationPreviewImage({double latitude, double longitude}) {
    var labelLetter = 'A'; // Just a fancy thing. The character here will show up inside the red bubble on the map
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:$labelLetter%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
    // Google makes it very easy to get a snapshot of the map if we have the lat/long of the place we want.
    // We did a modification of the url given in 'Google Maps Static API'. 
    // We put in coordinates wherever the demo url went place specific and also added our Google Cloud Platform project API key at the end.
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    // Idhar bhi google ki meherbaani ki wajah se, ek coordinates ki set ke saath, us location ka ek human readable format me address nikal sakthe hain.
    // URL got from geocoding API in Google Maps Platform
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
    // These string keys and stuff can be figured out by simply printing the response body and observing the map output, and then choosing whatever we want
  }
}