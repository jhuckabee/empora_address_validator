import 'package:dio/adapter.dart';
import 'package:empora_address_validator/vendor/address_validator/address_validator.dart';
import 'package:empora_address_validator/vendor/address_validator/address_validator_http_client.dart';
import 'package:empora_address_validator/vendor/address_validator/address_validator_local_http_adapter.dart';
import 'package:test/test.dart';

void main() {
  group('local validator', () {
    test('uses local HTTP adapter', () {
      final addressValidator = AddressValidator.local();
      final client = addressValidator.client as AddressValidatorHttpClient;
      expect(client.dio.httpClientAdapter,
          isA<AddressValidatorLocalHttpAdapter>());
    });
  });

  group('http validator', () {
    test('uses default HTTP adapter', () {
      final addressValidator = AddressValidator.http('12345');
      final client = addressValidator.client as AddressValidatorHttpClient;
      expect(client.dio.httpClientAdapter, isA<DefaultHttpClientAdapter>());
      expect(client.apiKey, '12345');
    });
  });
}
