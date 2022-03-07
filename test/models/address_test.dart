import 'package:test/test.dart';

import '../support/factories/address.dart';

void main() {
  test('has street address, city, and postal code', () {
    final address = AddressFactory.build();
    expect(address.streetAddress, isNotEmpty);
    expect(address.city, isNotEmpty);
    expect(address.postalCode, isNotEmpty);
  });
}
