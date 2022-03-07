import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:empora_address_validator/cli/commands/validate_address_csv_command.dart';
import 'package:test/test.dart';

var log = [];

void main() {
  late CommandRunner runner;

  setUp(() {
    final command = ValidateAddressCsvCommand();

    // Make sure [Command.runner] is set up.
    runner = CommandRunner('test', 'A test command runner.')
      ..addCommand(command);
  });

  test('throws UsageException with no specified file path', () async {
    expect(
      () async => await runner.run(['validate', '-k', '12345']),
      throwsA(isA<UsageException>()),
    );
  });

  test('with valid file path and key', overridePrint(
    () async {
      await runner.run([
        'validate',
        '-f',
        'test/support/fixtures/addresses.csv',
        '-k',
        '12345'
      ]);
      await expectLater(log, [
        '123 e Maine Street, Columbus, 43215 -> 123 e Maine Street, Columbus, 43215\n1 Empora St, Title, 11111 -> 1 Empora St, Title, 11111'
      ]);
    },
  ));
}

void Function() overridePrint(void Function() testFn) => () {
      var spec = ZoneSpecification(print: (_, __, ___, String msg) {
        log.add(msg);
      });
      return Zone.current.fork(specification: spec).run<void>(testFn);
    };
