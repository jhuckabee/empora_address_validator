import 'package:empora_address_validator/src/models/address.dart';
import 'package:empora_address_validator/src/services/bulk_validator.dart';
import 'package:empora_address_validator/vendor/address_validator/address_validator.dart';
import 'package:test/test.dart';

void main() {
  test('returns a list of validation results for each address ', () async {
    final validator = BulkAddressValidator(
        validatorClient: AddressValidator.local(), inputAddresses: []);
    final result = await validator.validate();

    expect(result.addressValidations.length, 0);
    expect(result.toString(), 'No addresses to validate.');
  });

  group('when address list is not empty', () {
    test('returns a list of validation results for each address ', () async {
      final addresses = [
        Address(
            streetAddress: '101 Valid Way',
            city: 'Flagstaff',
            postalCode: '86401'),
        Address(
            streetAddress: '101 Suspect Way',
            city: 'Flagstaff',
            postalCode: '86401'),
        Address(
            streetAddress: '101 Invalid Way',
            city: 'Flagstaff',
            postalCode: '86401'),
      ];
      final validator = BulkAddressValidator(
          validatorClient: AddressValidator.local(), inputAddresses: addresses);
      final result = await validator.validate();

      expect(result.addressValidations.length, 3);
      expect(result.toString(),
          '101 Valid Way, Flagstaff, 86401 -> 101 Valid Way, Flagstaff, 86401\n101 Suspect Way, Flagstaff, 86401 -> 101 Suspect Way, Flagstaff, 86401\n101 Invalid Way, Flagstaff, 86401 -> INVALID');
    });
  });
}
