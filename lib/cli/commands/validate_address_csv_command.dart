import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:empora_address_validator/src/parsers/address_parser.dart';
import 'package:empora_address_validator/src/services/bulk_validator.dart';
import 'package:empora_address_validator/vendor/address_validator/address_validator.dart';

const filePathOption = 'filePath';
const apiKeyOption = 'apiKey';
const environmentOption = 'environment';
const localEnvironment = 'local';
const liveEnvironment = 'live';
const apiKeyEnvironmentVariable = 'ADDRESS_VALIDATOR_API_KEY';

class ValidateAddressCsvCommand extends Command {
  @override
  final name = 'validate';

  @override
  final description =
      'Validates addresses in CSV formatted provided either from stdin or via a specified file path. Requires an AddressValidator.net API key to be specified either via the apiKey argument or via an \'$apiKeyEnvironmentVariable\' environment variable.';

  ValidateAddressCsvCommand() {
    argParser.addOption(environmentOption,
        abbr: 'e',
        defaultsTo: localEnvironment,
        allowed: [localEnvironment, liveEnvironment],
        help:
            'By default validation is run using a local validator. Set this to \'live\' to use the live API endpoint.');
    argParser.addOption(filePathOption,
        abbr: 'f',
        mandatory: true,
        help:
            'The path to the file containing a list of addresses in CSV format with the fields Street Address, City, and Postal Code.');
    argParser.addOption(apiKeyOption,
        abbr: 'k',
        help:
            'The address-validator.net API key. If the key is not specified via this option it must be specified via the $apiKeyEnvironmentVariable environment variable.');
  }

  @override
  Future<void> run() async {
    final String? apiKey =
        argResults![apiKeyOption] ?? env[apiKeyEnvironmentVariable];
    final path = argResults![filePathOption];
    final environment = argResults![environmentOption];

    if (environment == liveEnvironment && (apiKey == null || apiKey.isEmpty)) {
      print(
          'ERROR: Address-Validator.net API key not specified. Please provide an API key using the -k option or the $apiKeyEnvironmentVariable environment variable.');
      exit(1);
    }

    final clients = {
      localEnvironment: () => AddressValidator.local(),
      liveEnvironment: () => AddressValidator.http(apiKey!),
    };

    final parseResult = await AddressParser.parseFile(path);
    if (!parseResult.success) {
      print(parseResult.errorMessage ?? 'Unable to parse input file.');
      exit(64);
    }

    final bulkValidator = BulkAddressValidator(
      validatorClient: clients[environment]!(),
      inputAddresses: parseResult.addresses!,
    );
    final results = await bulkValidator.validate();
    print(results);
  }
}
