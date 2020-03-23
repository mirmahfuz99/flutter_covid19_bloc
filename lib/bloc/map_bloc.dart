import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercovid19bloc/bloc/state.dart';
import 'package:fluttercovid19bloc/model/covid19_bd_model.dart';
import 'package:fluttercovid19bloc/model/covid19_world_model.dart';
import 'package:fluttercovid19bloc/repository.dart';
import 'map_event.dart';

class Covid19MapDataBloc extends Bloc<Covid19Event, Covid19State> {
  Repository repository;

  Covid19MapDataBloc({this.repository});

  @override
  Covid19State get initialState => Covid19InitailState();

  @override
  Stream<Covid19State> mapEventToState(event) async* {
    if (event is Covid19DataMapEvent) {
      yield Covid19LoadingState();

      ///loading state

      try {
        final result = await repository.getCovid19CountryCase();
        yield Covid19CaseCountryState(allCasesFuture: result);
      } catch (e) {
        yield Covid19ErrorState(error: e.toString());
      }
    } else if (event is Covid19WorldDataEvent) {
      yield Covid19LoadingState();

      ///loading state

      try {
        final wordlData = repository.getCovid19WorldData(event.paramAll);
        final bdData = repository.getCovid19BDData(event.param);
        var results = await Future.wait([wordlData, bdData]);
        if (results[0].statusCode != 200) throw Exception();
        Covid19WorldModel allData = allDataFromJson(results[0].body);
        if (results[1].statusCode != 200) throw Exception();
        Covid19BdModel covidBdData = covid19BdDataFromJson(results[1].body);
        yield Covid19InfoState(
            covid19bdModel: covidBdData, covid19worldModel: allData);
      } catch (e) {
        yield Covid19ErrorState(error: e.toString());
      }
    }
  }

}