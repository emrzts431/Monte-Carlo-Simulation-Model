// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icara_sdk_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IcaraSdkMessageRequest _$IcaraSdkMessageRequestFromJson(
        Map<String, dynamic> json) =>
    IcaraSdkMessageRequest(
      method: json['method'] as String,
      params: json['params'] as List<dynamic>?,
      id: (json['id'] as num).toInt(),
    )..jsonrpc = json['jsonrpc'] as String;

Map<String, dynamic> _$IcaraSdkMessageRequestToJson(
        IcaraSdkMessageRequest instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'method': instance.method,
      'params': instance.params,
      'id': instance.id,
    };
