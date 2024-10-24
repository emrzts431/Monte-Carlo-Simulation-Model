import 'package:json_annotation/json_annotation.dart';
part 'icara_sdk_message_request.g.dart';

@JsonSerializable()
class IcaraSdkMessageRequest {
  String jsonrpc = '2.0';
  String method;
  List? params;
  int id;

  IcaraSdkMessageRequest({required this.method, this.params, required this.id});

  factory IcaraSdkMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$IcaraSdkMessageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$IcaraSdkMessageRequestToJson(this);
}
