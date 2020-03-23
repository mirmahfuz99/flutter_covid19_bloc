import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'model/corona_case.dart';
import 'model/corona_case_country.dart';
import 'model/corona_case_response.dart';

class TimeoutException implements Exception {
  final String message = 'Server timeout';
  TimeoutException();
  String toString() => message;
}

class ServerException implements Exception {
  final String message = 'Server busy';
  ServerException();
  String toString() => message;
}

class ServerErrorException implements Exception {
  String message;
  ServerErrorException(this.message);

  String toString() => message;
}

const kTimeoutDuration = Duration(seconds: 25);

class CoronaService {
  CoronaService._privateConstructor();
  static final CoronaService instance = CoronaService._privateConstructor();
  static var covid19_baseURL = "https://corona.lmao.ninja/";
  static var baseURL =  'https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query';

  static String get caseURL {
    return '$baseURL?f=json&where=(Confirmed%3E%200)%20OR%20(Deaths%3E0)%20OR%20(Recovered%3E0)&returnGeometry=false&spatialRef=esriSpatialRelIntersects&outFields=*&orderByFields=Country_Region%20asc,Province_State%20asc&resultOffset=0&resultRecordCount=250&cacheHint=false';
  }
  Future<List<CoronaCaseCountry>> fetchCases() async {
    try {
      final url = caseURL;
      final json = await _fetchJSON(url);
      final response = CoronaCaseResponse.fromJson(json);
      final coronaCases = response.features.map((e) => e.attributes).toList();

      Map<String, List<CoronaCase>> dict = Map();
      coronaCases.forEach((element) {
        if (dict[element.country] != null) {
          var countryCases = dict[element.country];
          countryCases.add(element);
          dict[element.country] = countryCases;
        } else {
          var countryCases = List<CoronaCase>();
          countryCases.add(element);
          dict[element.country] = countryCases;
        }
      });

      var coronaCountryCases = List<CoronaCaseCountry>();
      dict.forEach((key, value) {
        final confirmed = value.fold(
            0, (previousValue, element) => previousValue + element.confirmed);
        final deaths = value.fold(
            0, (previousValue, element) => previousValue + element.deaths);
        final recovered = value.fold(
            0, (previousValue, element) => previousValue + element.recovered);
        coronaCountryCases.add(CoronaCaseCountry(
            country: key,
            totalConfirmedCount: confirmed,
            totalDeathsCount: deaths,
            totalRecoveredCount: recovered,
            cases: value));
      });

      coronaCountryCases
          .sort((a, b) => b.totalRecoveredCount - a.totalRecoveredCount);
      coronaCountryCases
          .sort((a, b) => b.totalDeathsCount - a.totalDeathsCount);
      coronaCountryCases
          .sort((a, b) => b.totalConfirmedCount - a.totalConfirmedCount);

      return coronaCountryCases;
    } on PlatformException catch (_) {
      throw ServerException();
    } on Exception catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> _fetchJSON(String url) async {
    final response =
        await http.get(url).timeout(Duration(seconds: 25), onTimeout: () {
      throw Error();
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerErrorException("Error retrieving data");
    }
  }


  Future<Response> getCovid19Data(String param)async{
    try{
      final result= http.get(covid19_baseURL+"$param");
      return result;
    }catch(e){
      print("Error :${e.toString()}");
      throw Exception();
    }
  }
}
