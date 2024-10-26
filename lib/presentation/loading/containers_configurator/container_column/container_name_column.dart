import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
class ContainerNameColumn implements TableColumn<FreightContainer, String?> {
  const ContainerNameColumn();
  //
  @override
  String get key => 'name';
  //
  @override
  FieldType get type => FieldType.string;
  //
  @override
  String get name => const Localized('Name').v;
  //
  @override
  String get nullValue => '—';
  //
  @override
  String? get defaultValue => '';
  //
  @override
  Alignment get headerAlignment => Alignment.centerLeft;
  //
  @override
  Alignment get cellAlignment => Alignment.centerLeft;
  //
  @override
  double? get grow => null;
  //
  @override
  double? get width => 350.0;
  //
  @override
  bool get useDefaultEditing => false;
  //
  @override
  bool get isResizable => true;
  //
  @override
  Validator? get validator => null;
  //
  @override
  String? extractValue(FreightContainer container) {
    final name = 'OWN U ${container.serial.toString().padLeft(6, '0')}';
    final checkDigit = calculateCheckDigit(name.replaceAll(' ', ''));
    return '$name $checkDigit';
  }
  //
  @override
  String? parseToValue(String text) => text;
  //
  @override
  String parseToString(String? value) => value ?? nullValue;
  //
  @override
  FreightContainer copyRowWith(
    FreightContainer container,
    String text,
  ) =>
      container;
  //
  @override
  ValueRecord<String?>? buildRecord(
    FreightContainer container,
    String? Function(String text) toValue,
  ) =>
      null;
  //
  @override
  Widget? buildCell(context, cargo, updateValue) => null;
}
///
int calculateCheckDigit(String containerNumber) {
  Map<String, int> alphabetValues = {
    "A": 10, "B": 12, "C": 13, "D": 14, "E": 15, "F": 16, //
    "G": 17, "H": 18, "I": 19, "J": 20, "K": 21, //
    "L": 23, "M": 24, "N": 25, "O": 26, "P": 27, //
    "Q": 28, "R": 29, "S": 30, "T": 31, "U": 32, //
    "V": 34, "W": 35, "X": 36, "Y": 37, "Z": 38, //
  };
  List<int> numbers = [];
  for (String char in containerNumber.split('')) {
    if (alphabetValues.containsKey(char.toUpperCase())) {
      numbers.add(alphabetValues[char.toUpperCase()]!);
    } else if (int.tryParse(char) != null) {
      numbers.add(int.parse(char));
    }
  }
  List<int> multipliedNumbers = [];
  for (int i = 0; i < numbers.length; i++) {
    multipliedNumbers.add((numbers[i] * pow(2, i)).toInt());
  }
  int total = multipliedNumbers.reduce((a, b) => a + b);
  int remainder = total % 11;
  int checkDigit = remainder == 10 ? 0 : remainder;
  return checkDigit;
}
