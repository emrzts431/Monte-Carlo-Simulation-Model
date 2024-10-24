import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:ICARA/models/icara_sdk_message_request.dart';
import 'package:ICARA/models/icara_sdk_message_response.dart';

class IcarasdkViewModel extends ChangeNotifier {
  int _id = 0;

  bool _isLoading = false;
  get isLoading => _isLoading;

  bool _isSdkStarted = false;

  final String _serviceExecutable =
      'C:\\Users\\emre.oeztas\\Desktop\\ICARASdk\\bin\\Release\\net8.0\\ICARASdk.exe';

  Process? _csharpProcess;

  init() async {
    // if (!_isSdkStarted) {
    //   _csharpProcess = await Process.start(_serviceExecutable, []);
    //   _csharpProcess?.stdout.listen(_onDataReceived);
    //   debugPrint('Initiated Csharp process');
    //   _isSdkStarted = true;
    // }
  }

  dynamic _onDataReceived(event) {
    var strMessage = utf8.decode(event);
    if (strMessage != 'Icara SDK started\r\n') {
      var strJson = strMessage
          .split('\r\n')
          .where((element) => !element.contains('Content-Length'))
          .where((element) => element.trim().isNotEmpty)
          .first;

      IcaraSdkMessageResponse result =
          IcaraSdkMessageResponse.fromJson(jsonDecode(strJson));
      //Handle Result
      print(result.result);
    } else {
      debugPrint('Icara Initiated and ready');
    }
  }

  Future callMethod(String method, List? params) async {
    _id++;
    var message =
        IcaraSdkMessageRequest(method: method, id: _id, params: params);
    var jsonEncodedBody = jsonEncode(message.toJson());
    var contentLengthHeader = 'Content-Length: ${jsonEncodedBody.length}';
    var messagePayload = '$contentLengthHeader\r\n\r\n$jsonEncodedBody';
    _csharpProcess?.stdin.write(messagePayload);
  }
}
