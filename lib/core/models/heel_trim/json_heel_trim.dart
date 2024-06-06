import 'package:sss_computing_client/core/models/heel_trim/heel_trim.dart';
///
/// [HeelTrim] that parses itself from json map.
final class JsonHeelTrim implements HeelTrim {
  final Map<String, dynamic> _json;
  ///
  /// [HeelTrim] that parses itself from json map.
  const JsonHeelTrim({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  int get shipId => _json['shipId'];
  //
  @override
  int? get projectId => _json['projectId'];
  //
  @override
  double get heel => _json['heel'];
  //
  @override
  double get trim => _json['trim'];
  //
  @override
  ({double offset, double value}) get draftAP => _json['draftAP'];
  //
  @override
  ({double offset, double value}) get draftAvg => _json['draftAvg'];
  //
  @override
  ({double offset, double value}) get draftFP => _json['draftFP'];
}
