import 'package:empora_address_validator/models/address.dart';

const defaultStreetAddress = '101 W Main St';
const defaultCity = 'Wilmington';
const defaultPostalCode = '19702';

class AddressFactory {
  static Address build({
    String? streetAddress,
    String? city,
    String? postalCode,
  }) {
    return Address(
      streetAddress: streetAddress ?? defaultStreetAddress,
      city: city ?? defaultCity,
      postalCode: postalCode ?? defaultPostalCode,
    );
  }
}
