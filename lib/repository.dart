import 'package:http/http.dart';

import 'corona_service.dart';
import 'model/corona_case_country.dart';

class Repository {
  CoronaService _service;
  Repository(){
    this._service =  CoronaService.instance;
  }

  ///get countryCase Data to show on Map
  Future<List<CoronaCaseCountry>> getCovid19CountryCase() {
    try {
      return _service.fetchCases();
    }catch (e){
      print("Error :${e.toString()}");
      throw Exception();
    }
  }

  ///get covid19 bdInfo data to show
  Future<Response> getCovid19BDData(String param){
    try{
      return _service.getCovid19Data(param);
    }catch(e){
      print("Error :${e.toString()}");
      throw Exception();
    }
  }
  ///get covid19 world data to show
  Future<Response> getCovid19WorldData(String param){
    try{
      return _service.getCovid19Data(param);
    }catch(e){
      print("Error :${e.toString()}");
      throw Exception();
    }
  }



}