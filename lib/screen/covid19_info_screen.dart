import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercovid19bloc/bloc/map_bloc.dart';
import 'package:fluttercovid19bloc/bloc/map_event.dart';
import 'package:fluttercovid19bloc/bloc/state.dart';
import 'package:intl/intl.dart';

import '../custom_color.dart';
import '../repository.dart';
import '../utils.dart';


class Covid19InfoScreen extends StatefulWidget {
  @override
  _Covid19InfoScreenState createState() => _Covid19InfoScreenState();
}

class _Covid19InfoScreenState extends State<Covid19InfoScreen> with AutomaticKeepAliveClientMixin{
  Map<String, double> dataMap = new Map();
  Map<String, double> dataMapAll = new Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: BlocProvider<Covid19MapDataBloc>(
          create: (BuildContext context) =>
          Covid19MapDataBloc(repository: Repository())
            ..add(Covid19WorldDataEvent(
                param: "countries/bangladesh", paramAll: "all")),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                BlocBuilder<Covid19MapDataBloc, Covid19State>(
                  builder: (context, state) {
                    if (state is Covid19LoadingState) {
                      return Align(
                        alignment: Alignment.center,
                        child: Container(
                          color: primaryColorDark,
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: primaryColor,
                            ),
                          ),
                        ),
                      );
                    } else if (state is Covid19InfoState) {
                      if (state.covid19bdModel != null &&
                          state.covid19worldModel != null) {
                        dataMap.putIfAbsent("Confirmed",
                                () => state.covid19bdModel.cases.toDouble());
                        dataMap.putIfAbsent("Recovered",
                                () => state.covid19bdModel.recovered.toDouble());
                        dataMap.putIfAbsent("Deaths",
                                () => state.covid19bdModel.deaths.toDouble());

                        dataMapAll.putIfAbsent("Confirmed",
                                () => state.covid19worldModel.cases.toDouble());
                        dataMapAll.putIfAbsent("Recovered",
                                () => state.covid19worldModel.recovered.toDouble());
                        dataMapAll.putIfAbsent("Deaths",
                                () => state.covid19worldModel.deaths.toDouble());
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Card(
                                color: colorWhite,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Bangladesh Covid 19",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Utils().getChart(
                                          dataMap,
                                          [
                                            confirmedColor,
                                            recoveredColor,
                                            deathColor,
                                          ],
                                          context,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          _getItem(
                                              state.covid19bdModel.todayCases,
                                              "Today Confirmed"),
                                          _getItem(
                                              state.covid19bdModel.todayDeaths,
                                              "Today Deaths"),
                                          _getItem(
                                              state.covid19bdModel.deaths +
                                                  state.covid19bdModel
                                                      .recovered +
                                                  state.covid19bdModel.cases,
                                              "Reported cases"),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          _getItem(state.covid19bdModel.active,
                                              "Active Cases"),
                                          _getItem(
                                              state.covid19bdModel.critical,
                                              "Critical Cases"),
                                          _getItem(
                                              state.covid19bdModel
                                                  .casesPerOneMillion,
                                              "Cases Per Million"),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                color: colorWhite,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "World Covid 19 ",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                "Updated on",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blueGrey),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                " ${formatTimestamp(state.covid19worldModel.updated)}",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: Utils().getChart(
                                            dataMapAll,
                                            [
                                              confirmedColor,
                                              recoveredColor,
                                              deathColor
                                            ],
                                            context,
                                          )),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: <Widget>[
                                          _getItem(
                                              state.covid19worldModel.deaths +
                                                  state.covid19worldModel
                                                      .recovered +
                                                  state.covid19worldModel.cases,
                                              "Total Cases"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("There is something Error"),
                      ));
                    } else if (state is Covid19ErrorState) {
                      return Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("There is something Error",textAlign: TextAlign.center,),
                      ));
                    }
                    return Center(child: Text("There is something Error"));
                  },
                ),
              ],
            ),
          )),
    );
  }

  _getItem(final data, String level) {
    return Column(
      children: <Widget>[
        Text(
          "$data",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "$level",
          style: TextStyle(color: Colors.blueGrey),
        )
      ],
    );
  }

  String formatTimestamp(int timestamp) {
    var format = new DateFormat("MMM d, yyyy");
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    return format.format(date);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
