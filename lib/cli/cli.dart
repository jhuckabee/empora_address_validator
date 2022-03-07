import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:empora_address_validator/cli/commands/validate_address_csv_command.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner('av', 'Empora Address Validator')
    ..addCommand(ValidateAddressCsvCommand());

  runner.run(arguments).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64); // Exit code 64 indicates a usage error.
  });
}
