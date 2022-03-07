import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:empora_address_validator/vendor/address_validator/constants.dart';

final addressResultFixtures = {
  '101 Valid Way': {
    'status': 'VALID',
    'addressline1': '101 Valid Way',
    'city': 'Flagstaff',
    'postalcode': '86401',
  },
  '101 Suspect Way': {
    'status': 'SUSPECT',
    'addressline1': '101 Suspect Way',
    'city': 'Flagstaff',
    'postalcode': '86401',
  },
  '101 Invalid Way': {
    'status': 'INVALID',
    'addressline1': '101 Invalid Way',
    'city': 'Flagstaff',
    'postalcode': '86401',
  }
};

const defaultHeaders = {
  Headers.contentTypeHeader: [Headers.jsonContentType]
};

class AddressValidatorLocalHttpAdapter extends HttpClientAdapter {
  final jsonEncoder = JsonEncoder();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future? cancelFuture,
  ) async {
    var path = options.path;
    if (path == verifyAddressPath) {
      final street = options.queryParameters['StreetAddress'];
      if (street != null) {
        if (addressResultFixtures.containsKey(street)) {
          final data = addressResultFixtures[street]!;
          return _jsonResponse(data, 200);
        }

        return _jsonResponse(_defaultResponse(options.queryParameters), 200);
      }

      return _jsonResponse({'error': 'Invalid request'}, 500);
    }

    return _jsonResponse({'error': 'Unknown endpoint'}, 404);
  }

  @override
  void close({bool force = false}) {}

  ResponseBody _jsonResponse(Map<String, dynamic> data, int statusCode) {
    return ResponseBody.fromString(
      jsonEncoder.convert(data),
      statusCode,
      headers: defaultHeaders,
    );
  }

  Map<String, String> _defaultResponse(Map<String, dynamic> data) {
    return {
      'status': 'VALID',
      'addressline1': data['StreetAddress']!,
      'city': data['City']!,
      'postalcode': data['PostalCode']!,
    };
  }
}
