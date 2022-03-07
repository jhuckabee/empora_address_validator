import 'package:empora_address_validator/vendor/address_validator/address_validator_http_client.dart';
import 'package:empora_address_validator/vendor/address_validator/address_validator_local_http_adapter.dart';
import 'package:empora_address_validator/vendor/address_validator/models/address_validation_result.dart';
import 'package:test/test.dart';

void main() {
  final client = AddressValidatorHttpClient(
    apiKey: '1234',
    httpClientAdapter: AddressValidatorLocalHttpAdapter(),
  );

  group('when address is valid', () {
    test('returns valid result', () async {
      final result = await client.validate(
        street: '101 Valid Way',
        city: 'Flagstaff',
        postalCode: '86401',
      );

      expect(result.status, AddressValidationStatus.valid);
      expect(result.street, '101 Valid Way');
      expect(result.city, 'Flagstaff');
      expect(result.postalCode, '86401');
    });
  });

  group('when address is invalid', () {
    test('returns invalid result', () async {
      final result = await client.validate(
        street: '101 Invalid Way',
        city: 'Flagstaff',
        postalCode: '86401',
      );

      expect(result.status, AddressValidationStatus.invalid);
      expect(result.street, '101 Invalid Way');
      expect(result.city, 'Flagstaff');
      expect(result.postalCode, '86401');
    });
  });

  group('when address is suspect', () {
    test('returns suspect result', () async {
      final result = await client.validate(
        street: '101 Suspect Way',
        city: 'Flagstaff',
        postalCode: '86401',
      );

      expect(result.status, AddressValidationStatus.suspect);
      expect(result.street, '101 Suspect Way');
      expect(result.city, 'Flagstaff');
      expect(result.postalCode, '86401');
    });
  });

  group('when address is not part of fixture addresses', () {
    test('returns valid result', () async {
      final result = await client.validate(
        street: '82 Leslie Rd',
        city: 'Newburgh',
        postalCode: '12550',
      );

      expect(result.status, AddressValidationStatus.valid);
      expect(result.street, '82 Leslie Rd');
      expect(result.city, 'Newburgh');
      expect(result.postalCode, '12550');
    });
  });
}
