enum AddressValidationStatus { valid, suspect, invalid, error }

const addressValidationStatusMap = {
  'VALID': AddressValidationStatus.valid,
  'SUSPECT': AddressValidationStatus.suspect,
  'INVALID': AddressValidationStatus.invalid,
  'ERROR': AddressValidationStatus.error,
};

class AddressValidationResult {
  final AddressValidationStatus status;
  final String? street;
  final String? city;
  final String? postalCode;
  final String? errorMessage;

  const AddressValidationResult({
    required this.status,
    this.street,
    this.city,
    this.postalCode,
    this.errorMessage,
  });

  factory AddressValidationResult.error({
    required String errorMessage,
  }) {
    return AddressValidationResult(
        status: AddressValidationStatus.error, errorMessage: errorMessage);
  }
}
