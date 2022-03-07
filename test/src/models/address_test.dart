import 'package:test/test.dart';

import '../../support/factories/address.dart';

void main() {
  test('has street address, city, and postal code', () {
    final address = AddressFactory.build();
    expect(address.streetAddress, isNotEmpty);
    expect(address.city, isNotEmpty);
    expect(address.postalCode, isNotEmpty);
  });

  group('toString', () {
    test('returns comma separated street address, city and postal code', () {
      final address = AddressFactory.build(
        streetAddress: '145 S Cooley Rd',
        city: 'Cibecue',
        postalCode: '85911',
      );

      expect(address.toString(), '145 S Cooley Rd, Cibecue, 85911');
    });
  });
}
