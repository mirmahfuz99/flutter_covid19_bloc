import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercovid19bloc/bloc/map_bloc.dart';
import 'package:fluttercovid19bloc/bloc/map_event.dart';
import 'package:fluttercovid19bloc/bloc/state.dart';
import 'package:fluttercovid19bloc/model/corona_case_country.dart';
import 'package:fluttercovid19bloc/repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Covid19MapScreen extends StatefulWidget {
  @override
  _Covid19MapScreenState createState() => _Covid19MapScreenState();
}

class _Covid19MapScreenState extends State<Covid19MapScreen>
    with AutomaticKeepAliveClientMixin<Covid19MapScreen> {
  List<CoronaCaseCountry> cases;
  BitmapDescriptor myIcon;

  ///total list of case all over the world
  final Map<String, Marker> _markers = {};

  ///markers for map
  GoogleMapController mapController;

  ///onMapCreated Function to add markers to Google Map
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (cases == null) {
      return;
    }

    setState(() {
      _markers.clear();
      cases.forEach((element) {
        element.cases.forEach((element) {
          final totalCount = element.totalCount;
          final title = '${element.state} ${element.country}';
          final marker = Marker(
            icon: myIcon,
            markerId: MarkerId(title),
            position: LatLng(element.latitude, element.longitude),
            infoWindow: InfoWindow(
              title:
                  "${element.state != null ? element.state : 'N/A'}-${element.country}",
              snippet:
                  "C: ${totalCount.confirmedText} D: ${totalCount.deathsText} R: ${totalCount.recoveredText}",
            ),
          );
          _markers[title] = marker;
        });
      });
    });
  }

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/images/covid19.png')
        .then((onValue) {
      myIcon = onValue;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<Covid19MapDataBloc>(
          create: (BuildContext context) =>
              Covid19MapDataBloc(repository: Repository())
                ..add(Covid19DataMapEvent()),
          child: BlocBuilder<Covid19MapDataBloc, Covid19State>(
            builder: (context, state) {
              if (state is Covid19LoadingState) {
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (state is Covid19CaseCountryState) {
                if (state.allCasesFuture != null) {
                  this.cases = state.allCasesFuture;
                  return GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: const LatLng(23.777176, 90.399452),
                      zoom: 5,
                    ),
                    markers: _markers.values.toSet(),
                  );
                }
                return Container();
              } else if (state is Covid19ErrorState) {
                return Container();
              }
              return Container();
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'Get Location',
        child: Icon(Icons.flag),
      ),
    );
  }


  Future<String> _getAddress(Position pos) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      return pos.thoroughfare + ', ' + pos.locality;
    }
    return "";
  }

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print('got current location as ${currentLocation.latitude}, ${currentLocation.longitude}');
    var currentAddress = await _getAddress(currentLocation);
    await _moveToPosition(currentLocation);



    setState(() {
      _markers.clear();
      cases.forEach((element) {
        element.cases.forEach((element) {
          final totalCount = element.totalCount;
          final title = '${element.state} ${element.country}';
          final marker = Marker(
            icon: myIcon,
            markerId: MarkerId(title),
            position: LatLng(element.latitude, element.longitude),
            infoWindow: InfoWindow(
              title:
              "${element.state != null ? element.state : 'N/A'}-${element.country}",
              snippet:
              "C: ${totalCount.confirmedText} D: ${totalCount.deathsText} R: ${totalCount.recoveredText}",
            ),
          );
          _markers[title] = marker;
        });
      });
    });


  }
  Future<void> _moveToPosition(Position pos) async {
    if(mapController == null) return;
    print('moving to position ${pos.latitude}, ${pos.longitude}');
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 8,
          target: LatLng(pos.latitude, pos.longitude),
        )
    )
    );
  }


  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }
}
