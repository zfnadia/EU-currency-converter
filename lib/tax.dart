class Tax {
  final String countryName;
  final Map<String, dynamic> rates;

  Tax({this.countryName, this.rates});

  factory Tax.fromJson(Map<String, dynamic> parsedJson) {
    return Tax(
        countryName: parsedJson['name'],
        rates: (parsedJson['periods'] as List)[0]['rates']);
  }

  @override
  String toString() {
    return 'Tax{countryName: $countryName, rates: $rates}';
  }
}
