class Coupon {
  final String driverID;
  final String couponID;
  final int couponTime;
  final int couponAmount;

  Coupon({
    required this.driverID,
    required this.couponID,
    required this.couponTime,
    required this.couponAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'driverID': driverID,
      'couponID': couponID,
      'couponTime': couponTime,
      'couponAmount': couponAmount,
    };
  }

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      driverID: json['driverID'],
      couponID: json['couponID'],
      couponTime: int.parse(json['couponTime'].toString()),
      couponAmount: int.parse(json['couponAmount'].toString()),
    );
  }
}
