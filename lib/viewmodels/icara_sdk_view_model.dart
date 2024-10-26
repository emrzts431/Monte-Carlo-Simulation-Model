import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:ICARA/models/icara_sdk_message_request.dart';
import 'package:ICARA/models/icara_sdk_message_response.dart';
import 'package:logger/logger.dart';

class IcarasdkViewModel extends ChangeNotifier {
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
    ),
  );

  int _id = 0;

  bool _isLoading = false;
  get isLoading => _isLoading;

  bool _isSdkStarted = false;

  //TODO: Find a global spot or make it selectable!!!
  final String _serviceExecutable =
      'C:\\Users\\emre.oeztas\\Desktop\\ICARASdk\\bin\\Release\\net8.0-windows\\ICARASdk.exe';

  Process? _csharpProcess;

  Completer<IcaraSdkMessageResponse>? _sdkResponseCompleter;

  init() async {
    if (!_isSdkStarted) {
      _csharpProcess = await Process.start(_serviceExecutable, []);
      _csharpProcess?.stdout.listen(_onDataReceived);
      debugPrint('Initiated Csharp process');
      _isSdkStarted = true;
    }
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

      _sdkResponseCompleter!.complete(result);
    } else {
      debugPrint('Icara Initiated and ready');
    }
  }

  Future<IcaraSdkMessageResponse> callMethod(
      String method, List? params) async {
    _sdkResponseCompleter = Completer();
    _id++;
    var message =
        IcaraSdkMessageRequest(method: method, id: _id, params: params);
    var jsonEncodedBody = jsonEncode(message.toJson());
    var contentLengthHeader = 'Content-Length: ${jsonEncodedBody.length}';
    var messagePayload = '$contentLengthHeader\r\n\r\n$jsonEncodedBody';
    _logger.d(messagePayload);
    _csharpProcess?.stdin.write(messagePayload);
    return _sdkResponseCompleter!.future;
  }

  //Future
}
