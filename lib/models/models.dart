class WeatherModel {
  final String cityName;
  final double temp;
  final String mainCondition;
  WeatherModel({
    required this.cityName,
    required this.temp,
    required this.mainCondition,
  });
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temp: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
