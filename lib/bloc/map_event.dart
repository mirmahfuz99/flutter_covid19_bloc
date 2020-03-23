class Covid19Event{}

class Covid19DataMapEvent extends Covid19Event {
  final param; ///url after base url
  Covid19DataMapEvent({this.param});
}

class Covid19WorldDataEvent extends Covid19Event {
  final param;
  final paramAll;
  Covid19WorldDataEvent({this.param,this.paramAll});
}
