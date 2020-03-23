import 'package:flutter/material.dart';
import 'package:fluttercovid19bloc/model/corona_case_country.dart';
import 'package:fluttercovid19bloc/model/covid19_bd_model.dart';
import 'package:fluttercovid19bloc/model/covid19_world_model.dart';

class Covid19State {}

class Covid19InitailState extends Covid19State {}

class Covid19LoadingState extends Covid19State {}

///state to show data on map
class Covid19CaseCountryState extends Covid19State {
  List<CoronaCaseCountry> allCasesFuture;
  ///coronacase country list
  Covid19CaseCountryState({this.allCasesFuture});
}

///Covid19 state with bdCase and World Case
class Covid19InfoState extends Covid19State {
  Covid19BdModel covid19bdModel;
  Covid19WorldModel covid19worldModel;
  
  Covid19InfoState({this.covid19bdModel,this.covid19worldModel});
}

class Covid19ErrorState extends Covid19State {
  final error;
  Covid19ErrorState({this.error});

}