// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icara_sdk_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IcaraSdkMessageResponse _$IcaraSdkMessageResponseFromJson(
        Map<String, dynamic> json) =>
    IcaraSdkMessageResponse(
      id: (json['id'] as num).toInt(),
      result: json['result'],
    )..jsonrpc = json['jsonrpc'] as String;

Map<String, dynamic> _$IcaraSdkMessageResponseToJson(
        IcaraSdkMessageResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'result': instance.result,
    };
