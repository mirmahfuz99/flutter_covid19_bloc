import 'package:flutter/material.dart';
import 'package:fluttercovid19bloc/model/corona_case_country.dart';

class Covid19State {}

class Covid19InitailState extends Covid19State {}

class Covid19LoadingState extends Covid19State {}

class Covid19CaseCountryState extends Covid19State {

  List<CoronaCaseCountry> allCasesFuture;

  ///coronacase country list
  Covid19CaseCountryState({this.allCasesFuture});

}

class Covid19ErrorState extends Covid19State {
  final error;

  Covid19ErrorState({this.error});

}