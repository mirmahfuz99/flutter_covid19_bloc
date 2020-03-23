import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercovid19bloc/bloc/bloc.dart';
import 'package:fluttercovid19bloc/bloc/event.dart';
import 'package:fluttercovid19bloc/bloc/state.dart';
import 'package:fluttercovid19bloc/model/corona_case_country.dart';
import 'package:fluttercovid19bloc/repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Covid19MapScreen extends StatefulWidget {
  @override
  _Covid19MapScreenState createState() => _Covid19MapScreenState();
}

class _Covid19MapScreenState extends State<Covid19MapScreen>
    with AutomaticKeepAliveClientMixin<Covid19MapScreen> {


  List<CoronaCaseCountry> cases;

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
            markerId: MarkerId(title),
            position: LatLng(element.latitude, element.longitude),
            infoWindow: InfoWindow(
              title:
              "${element.state != null ? element.state : 'N/A'}-${element
                  .country}",
              snippet:
              "C: ${totalCount.confirmedText} D: ${totalCount
                  .deathsText} R: ${totalCount.recoveredText}",
            ),
          );
          _markers[title] = marker;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Covid 19"),
      ),
      body: BlocProvider<Covid19Bloc>(
          create: (BuildContext context) =>
          Covid19Bloc(repository: Repository())
            ..add(Covid19DataEvent()),
          child: BlocBuilder<Covid19Bloc, Covid19State>(
            builder: (context, state) {
              if (state is Covid19LoadingState) {
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child: Center(
                      child: CircularProgressIndicator(
                      ),
                    ),
                  ),
                );
              } else if (state is Covid19CaseCountryState) {
                if (state.allCasesFuture != null) {
                  this.cases = state.allCasesFuture;
                  return GoogleMap(
                    mapType: MapType.hybrid,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: const LatLng(23.777176, 90.399452),
                      zoom: 5,
                    ),
                    markers: _markers.values.toSet(),
                  );
                }
                return Container();
              }
              else if (state is Covid19ErrorState) {
                return Container();
              }
              return Container();
            },
          )


      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
