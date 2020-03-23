import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercovid19bloc/bloc/state.dart';
import 'package:fluttercovid19bloc/repository.dart';
import 'event.dart';

class Covid19Bloc extends Bloc<Covid19Event,Covid19State>{

  Repository repository;
  Covid19Bloc({this.repository});


  @override
  Covid19State get initialState => Covid19InitailState();

  @override
  Stream<Covid19State> mapEventToState(event) async*{
    if(event is Covid19DataEvent){
      yield Covid19LoadingState();

      try{
        final result = await repository.getCovid19CountryCase();
        yield Covid19CaseCountryState(allCasesFuture: result);
      }catch(e){
        yield Covid19ErrorState(error: e.toString());
      }
    }
  }

}