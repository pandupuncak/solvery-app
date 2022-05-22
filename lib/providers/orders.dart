import 'dart:html';
import 'package:json_annotation/json_annotation.dart';
import 'package:location/location.dart';

class Order {
  String? category;
  int? minimalCost;
  int? maximalCost;
  String? description;
  Location? order_location;
  DateTime? deadline;
  DateTime? timestamps;
  File? image_path;

  Order();

  Order.fromJson(Map<String, dynamic> json)
      : category = json['category'],
        minimalCost = json['cost']['minimalCost'],
        maximalCost = json['cost']['maximalCost'],
        description = json['description'],
        order_location = json['location']['value'],
        deadline = json['deadline']['value'],
        timestamps = json['timestamp'],
        image_path = json['order_image'];

  Map<String, dynamic> toJson() => {
        "category": category,
        "description": description,
        "minimalCost": minimalCost,
        "maximalCost": maximalCost,
        "order_location": order_location,
        "deadline": deadline.toString(),
        "timestamps": timestamps.toString(),
        "image_path": image_path.toString()
        // int? minimalCost;
        // int? maximalCost;
        // String? description;
        // Location? order_location;
        // DateTime? deadline;
        // DateTime? timestamps;
        // File? image_path;
      };
  // Map<String, dynamic> toJson() =>
  //     {'category': category, 'minimalCost': cost.maximal_cost};

  // Order.fromSnapshot(snapshot)
  //   : snapshot.data()['query'],
  //     snapshot.data()['answer'],
  //     created.data()['']

}
