class Vehicle {
  int id;
  String mark;
  String model;
  String? generation = "N/A";
  double consumptionCity;
  double consumptionRoute;
  double consumptionMixed;
  double fuelCapacity;
  String? licensePlateNumber = "N/A";

  Vehicle(
      {required this.id,
      required this.mark,
      required this.model,
      this.generation,
      required this.consumptionCity,
      required this.consumptionRoute,
      required this.consumptionMixed,
      required this.fuelCapacity,
      this.licensePlateNumber});

  Vehicle.fromJson(Map<String, dynamic> json)
      : id=int.parse(json['id'].toString()),
        mark = json['mark'].toString(),
        model = json['model'].toString(),
        generation = json['generation'] ?? 'N/A',
        consumptionCity = double.parse(json['consumptionCity'].toString()),
        consumptionRoute = double.parse(json['consumptionRoute'].toString()),
        consumptionMixed = double.parse(json['consumptionMixed'].toString()),
        fuelCapacity = double.parse(json['fuelCapacity'].toString()),
        licensePlateNumber = json['licensePlateNumber'] ?? 'N/A';

}
