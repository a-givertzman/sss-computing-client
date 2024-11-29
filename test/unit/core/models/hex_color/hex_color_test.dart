import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/hex_color.dart';
//
void main() {
  //
  group('HexColor', () {
    //
    test('parses hex string correctly', () {
      final testCases = <({String hexInput, Color colorOutput})>[
        (
          hexInput: '#FF0000',
          colorOutput: const Color.fromARGB(255, 255, 0, 0)
        ),
        (
          hexInput: '#00FF00',
          colorOutput: const Color.fromARGB(255, 0, 255, 0)
        ),
        (
          hexInput: '#0000FF',
          colorOutput: const Color.fromARGB(255, 0, 0, 255)
        ),
        (
          hexInput: '#FFFFFF',
          colorOutput: const Color.fromARGB(255, 255, 255, 255)
        ),
        (
          hexInput: '#000000',
          colorOutput: const Color.fromARGB(255, 0, 0, 0),
        ),
        (
          hexInput: '#00FF0000',
          colorOutput: const Color.fromARGB(0, 255, 0, 0)
        ),
        (
          hexInput: '#80FF0000',
          colorOutput: const Color.fromARGB(128, 255, 0, 0)
        ),
      ];
      for (final testCase in testCases) {
        final hexColor = HexColor(testCase.hexInput);
        expect(hexColor.color(), testCase.colorOutput);
      }
    });
    //
    test('returns default color if parsing fails', () {
      const defaultColor = Colors.transparent;
      final testCases = <({String hexInput, Color colorOutput})>[
        (
          hexInput: 'invalid hex',
          colorOutput: defaultColor,
        ),
        (
          hexInput: '1234567890',
          colorOutput: defaultColor,
        ),
        (
          hexInput: '#GGHHHH',
          colorOutput: defaultColor,
        ),
        (
          hexInput: '',
          colorOutput: defaultColor,
        ),
        (
          hexInput: '🐛🐛🐛🐛🐛🐛',
          colorOutput: defaultColor,
        ),
        (
          hexInput: '#🐛🐛🐛🐛🐛🐛',
          colorOutput: defaultColor,
        ),
        (
          hexInput: '#🪲🪲🐛🐛🐛🐛🐛🐛',
          colorOutput: defaultColor,
        ),
      ];
      for (final testCase in testCases) {
        final hexColor = HexColor(testCase.hexInput);
        expect(hexColor.color(), testCase.colorOutput);
      }
    });
    //
    test('returns orElse color if passed and parsing fails', () {
      final testCases = <({String hexInput, Color colorOutput})>[
        (
          hexInput: ' invalid hex ',
          colorOutput: Colors.red,
        ),
        (
          hexInput: '1234567890',
          colorOutput: Colors.black,
        ),
        (
          hexInput: '#GGHHHH',
          colorOutput: Colors.blue,
        ),
        (
          hexInput: '',
          colorOutput: Colors.transparent,
        ),
        (
          hexInput: '🐛🐛🐛🐛🐛🐛',
          colorOutput: Colors.green,
        ),
        (
          hexInput: '#🐛🐛🐛🐛🐛🐛',
          colorOutput: Colors.green,
        ),
        (
          hexInput: '#🪲🪲🐛🐛🐛🐛🐛🐛',
          colorOutput: Colors.green,
        ),
      ];
      for (final testCase in testCases) {
        final hexColor = HexColor(testCase.hexInput);
        expect(
          hexColor.color(orElse: (_) => testCase.colorOutput),
          testCase.colorOutput,
        );
      }
    });
    //
    test('converts color to hex string correctly', () {
      final testCases = <({String hexInput, String hexStringOutput})>[
        (
          hexInput: '#FF0000',
          hexStringOutput: '#FFFF0000',
        ),
        (
          hexInput: '#0000FF',
          hexStringOutput: '#FF0000FF',
        ),
        (
          hexInput: '#808080',
          hexStringOutput: '#FF808080',
        ),
      ];
      for (final testCase in testCases) {
        final hexColor = HexColor(testCase.hexInput);
        expect(
          hexColor.toHexString(includeSharp: true).toUpperCase(),
          testCase.hexStringOutput,
        );
      }
    });
    //
    test('converts color to hex string without sharp symbol', () {
      final testCases = <({String hexInput, String hexStringOutput})>[
        (
          hexInput: '#FF0000',
          hexStringOutput: 'FFFF0000',
        ),
        (
          hexInput: '#0000FF',
          hexStringOutput: 'FF0000FF',
        ),
        (
          hexInput: '#808080',
          hexStringOutput: 'FF808080',
        ),
      ];
      for (final testCase in testCases) {
        final hexColor = HexColor(testCase.hexInput);
        expect(
          hexColor.toHexString(includeSharp: false).toUpperCase(),
          testCase.hexStringOutput,
        );
      }
    });
  });
}
