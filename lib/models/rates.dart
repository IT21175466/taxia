class VehicleRates {
  double perCar;
  double perTuk;
  double perBike;

  VehicleRates({
    required this.perCar,
    required this.perTuk,
    required this.perBike,
  });

  Map<String, dynamic> toJson() {
    return {
      'perCar': perCar,
      'perTuk': perTuk,
      'perBike': perBike,
    };
  }

  factory VehicleRates.fromJson(Map<String, dynamic> json) {
    return VehicleRates(
      perCar: json['perCar'] ?? 0.0,
      perTuk: json['perTuk'] ?? 0.0,
      perBike: json['perBike'] ?? 0.0,
    );
  }
}
