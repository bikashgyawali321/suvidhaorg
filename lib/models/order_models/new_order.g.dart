// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewOrder _$NewOrderFromJson(Map<String, dynamic> json) => NewOrder(
      service: json['service'] as String,
      price: json['price'] as num,
      long: json['long'] as num,
      lat: json['lat'] as num,
    );

Map<String, dynamic> _$NewOrderToJson(NewOrder instance) => <String, dynamic>{
      'service': instance.service,      
      'price': instance.price,
      'long': instance.long,
      'lat': instance.lat,
    };
