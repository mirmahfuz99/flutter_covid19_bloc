
import 'dart:convert';

Covid19WorldModel allDataFromJson(String str) => Covid19WorldModel.fromJson(json.decode(str));

String allDataToJson(Covid19WorldModel data) => json.encode(data.toJson());

class Covid19WorldModel {
  int cases;
  int deaths;
  int recovered;
  int updated;

  Covid19WorldModel({
    this.cases,
    this.deaths,
    this.recovered,
    this.updated,
  });

  factory Covid19WorldModel.fromJson(Map<String, dynamic> json) => Covid19WorldModel(
    cases: json["cases"],
    deaths: json["deaths"],
    recovered: json["recovered"],
    updated: json["updated"],
  );

  Map<String, dynamic> toJson() => {
    "cases": cases,
    "deaths": deaths,
    "recovered": recovered,
    "updated": updated,
  };
}
