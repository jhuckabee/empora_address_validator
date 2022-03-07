Validates US addresses using the [Address Validator](https://www.address-validator.net/) API and displays the corrected
address or an `Invalid addresss` message if the address is invalid.

## Project Overview

[TODO] Outline high level project architecture and technical decisions.

## Running the Application

To run the application you can invoke the `av` binary in the `bin` directory. Invoking the executable without any
arguments will result in the following help message:

```
Option filePath is mandatory.

Usage: av validate [arguments]
-h, --help                    Print this usage information.
-e, --environment             By default validation is run using a local validator. Set this to 'live' to use the live API endpoint.
                              [local (default), live]
-f, --filePath (mandatory)    The path to the file containing a list of addresses in CSV format with the fields Street Address, City, and Postal Code.
-k, --apiKey                  The address-validator.net API key. If the key is not specified via this option it must be specified via the ADDRESS_VALIDATOR_API_KEY environment variable.

Run "av help" to see global options.
```

#### File path

A CSV file path is required to run the application. The file path must be specified relative to the root of the project
directory.

#### Environment

By default, the application runs in local mode which does not attempt to perform address validations using the
adddress-validator.net API endpointment. To use the live API endpoint set the environment to `live` by using
the `environment` option.

#### API key

As noted in the help text, you will need an address-validator.net API key when running the progranm in `live` model.
This can be specified either via the `-k` command line option, or by setting the key in a `ADDRESS_VALIDATOR_API_KEY`
environment variable.

#### Examples

**1:** Running the application in local mode using one of the fixture files in the `test/support/fixutres` directory:

```
./bin/av validate -f test/support/fixtures/addresses.csv
```

**2:** Running the application in live mode using one of the fixture files in the `test/support/fixutres` directory:

```
./bin/av validate -k av-?????-your-key -e live -f test/support/fixtures/addresses.csv
```

## Development

This application is built using [Dart](https://dart.dev). The easiest way to install Dart on a Mac is using homebrew.

```sh
brew tap dart-lang/dart
brew install dart
```

This application requires Dart SDK version 2.16.1 or higher.

### Dependencies

Dart's default package manager is [pub](https://pub.dev/). Once Dart is installed, you can initialize the project's
dependencies by running:

```sh
dart pub install
```

Project dependencies are managed in the `pubspec.yaml` file.

### Tests

To run the test suite, ensure you have Dart and all project dependencies installed (see above), and then run:

```sh
dart test
```

### Build

A build script is located in the `bin` directory which will create a new version of application executable. To generate
a new executable, you can run the build script using:

```sh
./bin/build.sh
```

This will generate a new binary at `bin/av`.
