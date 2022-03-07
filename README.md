Validates US addresses using the [Address Validator](https://www.address-validator.net/) API and displays the corrected
address or an `Invalid address` message if the address is invalid.

## Running the Application

To run the application you can invoke the `av` executable located in the `bin` directory. Invoking the executable without
any arguments or with the `-h` option will result in the following help message:

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
the `environment` option. See examples below.

#### API key

As noted in the help text, you will need an [address-validator.net](https://www.address-validator.net/) API key when running the program in `live` mode. This
can be specified either via the `-k` command line option, or by setting the key in an environment variable
named `ADDRESS_VALIDATOR_API_KEY`.

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

This application requires Dart SDK version 2.16.1 or higher. This is the default version as of March 7, 2022.

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

## Architectural Overview

The project has been broken down into three main components:

1. **Core:** A core library which facilitates basic address modeling, parsing, and other core business logic. This code
   lives in the `lib/src` directory.
2. **Vendor:** Vendor dependencies required by the application (namely the address-validator.net API) are wrapped in
   their own client libraries and live in the `lib/vendor` directory.
3. **Interfaces:** Application interfaces (currently only the CLI) which lives in `lib/cli`.

### Approach

An inside-out approach was taken while developing the application. I started with the core components that I knew would
be necessary for completing the stated requirements. Namely, modeling a simple Address object, parsing CSV input into
that format, and providing simple human-readable textual representations compatible with the required output format.

The second phase of development consisted of wrapping the address-validator.net API in a clean client library. With all
external client wrappers it is important to have a local-only implementation to use for testing/debugging purposes.

Dart's factory constructors came in handy here by making it very explicit which client you are using.
e.g. `AddressValidator.local` vs `AddressValidator.http(apiKey)`. It could be argued that there are better naming
alternatives here. `local` vs. `remote` perhaps? What would you choose? Regardless, each client is using an adapter to
facilitate the actual validation under the hood. The local client uses an adapter which bypasses all HTTP interaction
and returns a canned response from a predefined set of fixtures.

This adapter approach does speed up testing and avoids unnecessary HTTP calls where each call may have an associated
cost. However, it doesn't come without drawbacks. One drawback is that the custom adapter must be kept in sync with the
expectations of the live endpoint. This could get a little more complicated when the API endpoint is versioned.

The final phase of development consisted of exposing the internal workings of the application to the command line. Dart
also has great tooling to support this by way of [args](https://pub.dev/packages/args)
and [dcli](https://pub.dev/packages/dcli). The combination of these packages provide a clean way to instrument command
line utilities while being able to cleanly separate individual commands using a command object pattern. This provides a
solid base for adding additional commands to the application in the future.

### Assumptions / Improvements

#### Command line interface

The command line interface could probably be simplified such that running the command without and API key being specified assumes you want to run in local mode. In this case it may be prudent to add a message to the output indicating the mode you are running in.

#### Display logic

In all cases where system output was required, it was simple enough to just override `Object#toString()` in the
corresponding system component. However, if this system were to be expanded and that display logic needed to be
conditional in any way, that logic may need to be pulled up the stack. This could easily be accomplished using a
decorator or similar behavioral pattern.

#### 3rd party dependencies

In a larger project, it would probably make more sense to pull out the `address_validator` client in the `vendor`
directory into its own package. Ideally, it would also be open-sourced. For the purposes of this exercise, I think the
provided approach suffices.

#### Country code

The address-validator.net API endpoint requires a country code. For the purposes of this exercise all addresses are
assumed to be in the US. Additional work would be required to add in the ability to specify the country should that
assumption not hold.
