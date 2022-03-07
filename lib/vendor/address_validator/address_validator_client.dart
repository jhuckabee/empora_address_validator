import 'package:empora_address_validator/vendor/address_validator/models/address_validation_result.dart';

abstract class AddressValidatorClient {
  Future<AddressValidationResult> validate({
    required String street,
    required String city,
    required String postalCode,
  });
}
