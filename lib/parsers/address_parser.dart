import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:empora_address_validator/models/address.dart';

const invalidCsv = 'Invalid CSV file.';
const invalidFieldLength =
    'Invalid field length. Each record must include street address, city, and postal code.';
const invalidFilePath = 'Invalid file path.';
const headerRow = ['Street Address', 'City', 'Postal Code'];

class AddressParser {
  static Future<_AddressParseResult> parseFile(String path) async {
    final csvFile = File(path);
    final exists = await csvFile.exists();
    if (!exists) {
      return _AddressParseResult.error(invalidFilePath);
    }

    final fileContents = await csvFile.readAsString();

    return parse(fileContents);
  }

  static _AddressParseResult parse(String csv) {
    if (csv.isEmpty) {
      return _AddressParseResult.error(invalidCsv);
    }

    const settingsDetector = FirstOccurrenceSettingsDetector(
      eols: ['\r\n', '\n'],
      textDelimiters: ['"', "'"],
    );
    const converter = CsvToListConverter(
      allowInvalid: false,
      csvSettingsDetector: settingsDetector,
    );
    List<List<dynamic>> parsedRows;

    try {
      parsedRows = converter.convert(csv);
    } catch (error) {
      return _AddressParseResult.error(error.toString());
    }

    List<List<String>> converted = _rowToTrimmedStringList(parsedRows);

    if (converted.any((c) => c.length != 3)) {
      return _AddressParseResult.error(invalidFieldLength);
    }

    if (_isHeaderRow(converted[0])) {
      converted = converted.skip(1).toList();
    }

    final addresses = converted.map((data) {
      return Address(
          streetAddress: data[0].trim(),
          city: data[1].trim(),
          postalCode: data[2].toString());
    }).toList();

    return _AddressParseResult.success(addresses);
  }

  static List<List<String>> _rowToTrimmedStringList(List<List<dynamic>> rows) {
    return rows
        .map((row) => row.map((r) => r.toString().trim()).toList())
        .toList();
  }

  static bool _isHeaderRow(List<String> row) {
    return row.length == headerRow.length &&
        List.generate(headerRow.length, (i) => i)
            .every((index) => row[index] == headerRow[index]);
  }
}

class _AddressParseResult {
  final bool success;
  final String? errorMessage;
  final List<Address>? addresses;

  _AddressParseResult({
    required this.success,
    this.errorMessage,
    this.addresses,
  });

  factory _AddressParseResult.success(List<Address> addresses) {
    return _AddressParseResult(success: true, addresses: addresses);
  }

  factory _AddressParseResult.error(String errorMessage) {
    return _AddressParseResult(success: false, errorMessage: errorMessage);
  }
}
