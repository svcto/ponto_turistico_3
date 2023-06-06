import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatefulWidget{
  final double latitude;
  final double longitude;

  MapaPage({Key? key, required this.latitude, required this.longitude}) : super(key: key);

  @override
  _MapaPageState createState() => _MapaPageState();
}



class _MapaPageState extends State<MapaPage>{
  final _controller = Completer<GoogleMapController>();
  StreamSubscription<Position>? _subscription;

  @override
  void initState(){
    _monitorarLocalizacao();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    _subscription?.cancel();
    _subscription = null;
  }


  void _monitorarLocalizacao(){
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    _subscription = Geolocator.getPositionStream(
        locationSettings: locationSettings
    ).listen((Position position) async {
      final controller = await _controller.future;
      final zoom = await controller.getZoomLevel();
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(position.latitude, position.longitude),
              zoom: zoom)
      ));
    });
  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {
          Marker(
              markerId: const MarkerId('1'),
              position: LatLng(widget.latitude -1, widget.longitude-1),
              infoWindow: const InfoWindow(
                  title: 'Nome do ponto turístico'
              )
          )
        },


        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
        myLocationEnabled: true,

      ),
    );
  }
}