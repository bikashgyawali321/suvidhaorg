
import 'package:json_annotation/json_annotation.dart';
part 'new_order.g.dart';
@JsonSerializable()
class NewOrder {
  String service;
  num price;
  num long;
  num lat;
    
    NewOrder({
      required this.service,
      required this.price,
      required this.long,
      required this.lat
    });
      
      
      factory NewOrder.fromJson(Map<String, dynamic> json) => _$NewOrderFromJson(json);

      Map<String, dynamic> toJson() => _$NewOrderToJson(this);
}