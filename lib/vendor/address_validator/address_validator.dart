import 'package:empora_address_validator/vendor/address_validator/address_validator_client.dart';
import 'package:empora_address_validator/vendor/address_validator/address_validator_http_client.dart';
import 'package:empora_address_validator/vendor/address_validator/address_validator_local_http_adapter.dart';
import 'package:empora_address_validator/vendor/address_validator/models/address_validation_result.dart';

class AddressValidator implements AddressValidatorClient {
  final AddressValidatorClient client;

  AddressValidator(this.client);

  factory AddressValidator.http(String apiKey) {
    return AddressValidator(AddressValidatorHttpClient(apiKey: apiKey));
  }

  factory AddressValidator.local() {
    final httpClient = AddressValidatorHttpClient(
      apiKey: 'local',
      httpClientAdapter: AddressValidatorLocalHttpAdapter(),
    );

    return AddressValidator(httpClient);
  }

  @override
  Future<AddressValidationResult> validate({
    required String street,
    required String city,
    required String postalCode,
  }) async {
    return await client.validate(
      street: street,
      city: city,
      postalCode: postalCode,
    );
  }
}
