import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:empora_address_validator/vendor/address_validator/address_validator_client.dart';
import 'package:empora_address_validator/vendor/address_validator/constants.dart';
import 'package:empora_address_validator/vendor/address_validator/models/address_validation_result.dart';

const countryCode = 'us';
const apiError = 'API error';

class AddressValidatorHttpClient implements AddressValidatorClient {
  final String apiKey;
  final Dio dio = Dio(
    BaseOptions(baseUrl: baseUrl),
  );

  AddressValidatorHttpClient({
    required this.apiKey,
    HttpClientAdapter? httpClientAdapter,
  }) {
    dio.httpClientAdapter = httpClientAdapter ?? DefaultHttpClientAdapter();
  }

  @override
  Future<AddressValidationResult> validate(
      {required String street,
      required String city,
      required String postalCode}) async {
    Response result;
    try {
      result = await dio.get(verifyAddressPath, queryParameters: {
        'StreetAddress': street,
        'City': city,
        'PostalCode': postalCode,
        'CountryCode': countryCode,
        'APIKey': apiKey,
      });
    } catch (error) {
      return AddressValidationResult.error(errorMessage: error.toString());
    }

    if (result.statusCode != 200) {
      return AddressValidationResult.error(errorMessage: apiError);
    }

    return AddressValidationResult(
      status: addressValidationStatusMap[result.data['status']!]!,
      street: result.data['addressline1'],
      city: result.data['city'],
      postalCode: result.data['postalcode'],
    );
  }
}
