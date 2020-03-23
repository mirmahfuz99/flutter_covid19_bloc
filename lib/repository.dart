import 'corona_service.dart';
import 'model/corona_case_country.dart';

class Repository {
  CoronaService _service;
  Repository(){
    this._service =  CoronaService.instance;
  }

  Future<List<CoronaCaseCountry>> getCovid19CountryCase() {
    try {
      return _service.fetchCases();
    }catch (e){
      print("Error :${e.toString()}");
      throw Exception();
    }
  }
}