class Coupon {
  final String driverID;
  final String couponID;
  final int couponTime;
  final int couponAmount;
  final String couponEndDate;

  Coupon({
    required this.driverID,
    required this.couponID,
    required this.couponTime,
    required this.couponAmount,
    required this.couponEndDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'driverID': driverID,
      'couponID': couponID,
      'couponTime': couponTime,
      'couponAmount': couponAmount,
      'couponEndOn': couponEndDate,
    };
  }

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      driverID: json['driverID'],
      couponID: json['couponID'],
      couponTime: int.parse(json['couponTime'].toString()),
      couponAmount: int.parse(json['couponAmount'].toString()),
      couponEndDate: json['couponEndOn'].toString(),
    );
  }
}
