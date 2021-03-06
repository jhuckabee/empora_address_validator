class Address {
  final String streetAddress;
  final String city;
  final String postalCode;

  const Address({
    required this.streetAddress,
    required this.city,
    required this.postalCode,
  });

  @override
  String toString() {
    return [streetAddress, city, postalCode].join(', ');
  }
}
