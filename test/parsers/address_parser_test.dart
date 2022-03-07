import 'package:empora_address_validator/parsers/address_parser.dart';
import 'package:test/test.dart';

void main() {
  group('parse', () {
    test('with header row, returns list of addresses', () {
      final csvData =
          'Street Address, City, Postal Code\n123 e Maine Street, Columbus, 43215\n1 Empora St, Title, 11111';
      final parseResult = AddressParser.parse(csvData);

      expect(parseResult.success, true);
      expect(parseResult.addresses!.length, 2);
      expect(parseResult.addresses![0].toString(),
          '123 e Maine Street, Columbus, 43215');
      expect(parseResult.addresses![1].toString(), '1 Empora St, Title, 11111');
    });

    test('without header row, returns list of addresses', () {
      final csvData =
          '123 e Maine Street, Columbus, 43215\n1 Empora St, Title, 11111';
      final parseResult = AddressParser.parse(csvData);

      expect(parseResult.success, true);
      expect(parseResult.addresses!.length, 2);
    });

    test('with invalid data, returns an error result', () {
      final csvData = '123 e Maine Street, Columbus\n1 Empora St, Title, 11111';
      final parseResult = AddressParser.parse(csvData);

      expect(parseResult.success, false);
      expect(parseResult.errorMessage, invalidFieldLength);
    });

    test('with an empty string, returns an invalid CSV error', () {
      final parseResult = AddressParser.parse('');

      expect(parseResult.success, false);
      expect(parseResult.errorMessage, invalidCsv);
    });
  });
}
