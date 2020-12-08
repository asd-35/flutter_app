import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  GoogleMapController mapController;
  Location _location = Location();
  LocationData _locationData;
  File _image;
  final picker = ImagePicker();
  List<Marker> markers = [];
  bool submit;

  Widget createSubmitForm(File img){

  }
  watchLocation() async {
    _location.onLocationChanged.listen((LocationData currentLocation) {
      LatLng latLng =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(latLng, 15);
      mapController.animateCamera(cameraUpdate);

      setState(() {
        this._locationData = currentLocation;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    watchLocation();
    markers.add(Marker(markerId: MarkerId("1"), position: LatLng(38.2744,27.1799) , onTap: (){
      Navigator.pushNamed(context, '/info');
    },
     ));
  }

  Future getImage(bool cam) async {
    if (cam) {
      final picked = await picker.getImage(source: ImageSource.camera);

      setState(() {
        if (picked != null) {
          print("photo taken");
          _image = File(picked.path);

          submit = true;
        } else {
          print('Photo was not taken');
          submit = false;
          print(submit);
        }
      });
    }

  }

  @override
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Icon(
          Icons.account_balance_rounded,
          color: Colors.black,
          size: 20.0,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.apps_outlined),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
            color: Colors.black,
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.photo_camera_outlined,
            color: Colors.black,
          ),
          onPressed: () async {
            await getImage(true);

            if (submit) {
              Navigator.pushNamed(context,"/submit",arguments: {
                "img" : _image
              });
              submit = false;
            }
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              markers: Set.from(markers),

              initialCameraPosition: CameraPosition(
                target: LatLng(this._locationData?.latitude ?? 41.015137,
                    this._locationData?.longitude ?? 28.979530),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
              }),
        ],
      ),
    );
  }

}
