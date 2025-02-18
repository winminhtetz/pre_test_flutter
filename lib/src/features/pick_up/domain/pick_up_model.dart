import 'dart:convert';

Pickup pickupFromJson(String str) => Pickup.fromJson(json.decode(str));


class Pickup {
    final List<Item> items;
    final int totalRecords;
    final double totalDue;
    final double totalAmount;
    final dynamic codSummaryItem;
    final double totalWays;

    Pickup({
        required this.items,
        required this.totalRecords,
        required this.totalDue,
        required this.totalAmount,
        required this.codSummaryItem,
        required this.totalWays,
    });

    factory Pickup.fromJson(Map<String, dynamic> json) => Pickup(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        totalRecords: json["totalRecords"],
        totalDue: json["totalDue"],
        totalAmount: json["totalAmount"],
        codSummaryItem: json["codSummaryItem"],
        totalWays: json["totalWays"],
    );


}

class Item {
   final String trackingId;
  final String osName;
  final String pickupDate;
  final String osPrimaryPhone;
  final String osTownshipName;
  final int totalWays;

  Item({
    required this.trackingId,
    required this.osName,
    required this.pickupDate,
    required this.osPrimaryPhone,
    required this.osTownshipName,
    required this.totalWays,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      trackingId: json['trackingId'],
      osName: json['osName'],
      pickupDate: json['pickupDate'],
      osPrimaryPhone: json['osPrimaryPhone'],
      osTownshipName: json['osTownshipName'],
      totalWays: json['totalWays'],
    );
  }
}
