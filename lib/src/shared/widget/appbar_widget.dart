// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last, use_build_context_synchronously


import 'package:app_ppmob/src/services/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AppBarCustom extends StatefulWidget {
  final String title;
  const AppBarCustom({super.key, required this.title});

  @override
  _AppBarCustomState createState() => _AppBarCustomState();
}

class _AppBarCustomState extends State<AppBarCustom> {
  bool _isGpsActive = false;

  @override
  void initState() {
    super.initState();
    _checkGpsStatus();
  }

  Future<void> _checkGpsStatus() async {
    bool isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _isGpsActive = isGpsEnabled;
    });
  }

  Widget txtTitulo(BuildContext context) {
    return Text(
      widget.title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary,
        height: 0.5,
      ),
      // overflow: TextOverflow.ellipsis,
      // textAlign: TextAlign.left,
    );
  }

  Widget gpsGeolocator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 15.0, 0),
      child: GestureDetector(
        onTap: () async {
          bool isGpsEnabled = await Geolocator.isLocationServiceEnabled();
          if (!isGpsEnabled) {
            final status = await Geolocator.requestPermission();
            if (status == LocationPermission.always || status == LocationPermission.whileInUse) {
              setState(() {
                _isGpsActive = true;
              });
            }
          }
        },
        child: CircleAvatar(
          radius: 13,
          backgroundColor: _isGpsActive ? Colors.green : Colors.red,
          child: const Icon(
            Icons.gps_fixed,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            txtTitulo(context),
            // const Spacer(),
            gpsGeolocator(),
          ],
        );
      },
    );
  }
}
