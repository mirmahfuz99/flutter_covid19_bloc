import 'package:json_annotation/json_annotation.dart';

import 'corona_case.dart';

part 'corona_case_features.g.dart';

@JsonSerializable()
class CoronaCaseFeatures {
  final CoronaCase attributes;

  CoronaCaseFeatures({this.attributes});

  factory CoronaCaseFeatures.fromJson(Map<String, dynamic> json) =>
      _$CoronaCaseFeaturesFromJson(json);
  Map<String, dynamic> toJSON() => _$CoronaCaseFeaturesToJson(this);
}
