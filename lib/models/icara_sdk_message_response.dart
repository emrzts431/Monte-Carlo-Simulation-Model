import 'package:json_annotation/json_annotation.dart';
part 'icara_sdk_message_response.g.dart';

@JsonSerializable()
class IcaraSdkMessageResponse {
  String jsonrpc = '2.0';
  int id;
  dynamic result;

  IcaraSdkMessageResponse({required this.id, this.result});

  factory IcaraSdkMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$IcaraSdkMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IcaraSdkMessageResponseToJson(this);
}
