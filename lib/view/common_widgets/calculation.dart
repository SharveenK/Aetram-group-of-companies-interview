class Temperature {
  Temperature.celsius(this.tempValues);
  Temperature.farhenheit(this.tempValues);
  factory Temperature.changeToFarhenheit(double kelvin) =>
      Temperature.farhenheit(((kelvin - absoluteZero) * (9 / 5)) + 32);
  factory Temperature.changeToCelsius(double kelvin) =>
      Temperature.celsius(kelvin - absoluteZero);

  static double absoluteZero = 273.15;

  final double tempValues;
  @override
  String toString() {
    return tempValues.toStringAsFixed(2);
  }
}
