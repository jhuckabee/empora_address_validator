import 'package:empora_address_validator/src/models/address.dart';
import 'package:empora_address_validator/vendor/address_validator/address_validator.dart';
import 'package:empora_address_validator/vendor/address_validator/models/address_validation_result.dart';

const noAddressesError = 'No addresses to validate.';
const invalidAddressLabel = 'INVALID';

class BulkAddressValidator {
  final AddressValidator validatorClient;
  final List<Address> inputAddresses;

  BulkAddressValidator({
    required this.validatorClient,
    required this.inputAddresses,
  });

  Future<BulkValidationResult> validate() async {
    final List<AddressValidation> validations = [];

    for (var address in inputAddresses) {
      final validationResult = await validatorClient.validate(
        street: address.streetAddress,
        city: address.city,
        postalCode: address.postalCode,
      );

      validations.add(
        AddressValidation(
          isValid: validationResult.status != AddressValidationStatus.invalid,
          inputAddress: address,
          validatedAddress: Address(
            streetAddress: validationResult.street ?? address.streetAddress,
            city: validationResult.city ?? address.city,
            postalCode: validationResult.postalCode ?? address.postalCode,
          ),
        ),
      );
    }

    return BulkValidationResult(validations);
  }
}

class BulkValidationResult {
  final List<AddressValidation> addressValidations;

  BulkValidationResult(this.addressValidations);

  @override
  String toString() {
    if (addressValidations.isEmpty) return noAddressesError;

    return addressValidations.map((addressValidation) {
      return '${addressValidation.inputAddress.toString()} -> ${addressValidation.isValid ? addressValidation.validatedAddress.toString() : invalidAddressLabel}';
    }).join('\n');
  }
}

class AddressValidation {
  final bool isValid;
  final Address inputAddress;
  final Address validatedAddress;

  AddressValidation({
    required this.isValid,
    required this.inputAddress,
    required this.validatedAddress,
  });
}
