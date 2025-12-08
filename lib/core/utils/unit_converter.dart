class UnitConverter {
  static double celsiusToFahrenheit(double value) => (value * 9 / 5) + 32;
  static double fahrenheitToCelsius(double value) => (value - 32) * 5 / 9;
  static double mpsToKmh(double value) => value * 3.6;
  static double mpsToMph(double value) => value * 2.23694;
  static double kmhToMph(double value) => value / 1.609;

  /// Convert Celsius temperature into preferred unit (C or F).
  static double convertTemperature(double celsius, String unit) {
    if (unit.toUpperCase() == 'F') return celsiusToFahrenheit(celsius);
    return celsius;
  }

  /// Convert wind speed from meters/second into preferred unit.
  static double convertWindSpeed(double metersPerSecond, String unit) {
    switch (unit.toLowerCase()) {
      case 'km/h':
      case 'kmh':
        return mpsToKmh(metersPerSecond);
      case 'mph':
        return mpsToMph(metersPerSecond);
      default:
        return metersPerSecond;
    }
  }
}
