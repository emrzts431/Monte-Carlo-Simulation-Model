import 'package:ICARA/data/app_logger.dart';
import 'package:ICARA/data/preferences.dart';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:ICARA/widgets/snackbar_holder.dart';
import 'package:file_picker/file_picker.dart';
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

  Process? _csharpProcess;

  Completer<IcaraSdkMessageResponse>? _sdkResponseCompleter;

  init(BuildContext context) async {
    if (!_isSdkStarted) {
      try {
        String? _serviceExecutable = await Preferences.getSdkLocation();
        if (_serviceExecutable == null || _serviceExecutable.isEmpty) {
          _serviceExecutable = await _pickSdkFile();
          await Preferences.setSdkLocation(_serviceExecutable);
        }
        _csharpProcess = await Process.start(_serviceExecutable ?? "", []);
        _csharpProcess?.stdout.listen(_onDataReceived);
        debugPrint('Initiated Csharp process');
        _isSdkStarted = true;
      } on Exception catch (e, stackTrace) {
        AppLogger.instance.error(e, stackTrace);
        SnackbarHolder.showSnackbar(
          "An error happened while starting the sdk",
          true,
          context,
        );
      }
    }
  }

  Future<String?> _pickSdkFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Please select the ICARA Sdk",
      type: FileType.custom,
      allowedExtensions: ['exe'],
    );
    if (result != null) {
      return result.paths.first;
    }
    return null;
  }

  dynamic _onDataReceived(event) {
    var strMessage = utf8.decode(event);
    if (strMessage != 'Icara SDK started\r\n') {
      _isLoading = false;
      notifyListeners();
      var strJson = strMessage
          .split('\r\n')
          .where((element) => !element.contains('Content-Length'))
          .where((element) => element.trim().isNotEmpty)
          .first;
      AppLogger.instance.debug(strJson);
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
    _isLoading = true;
    notifyListeners();
    var message =
        IcaraSdkMessageRequest(method: method, id: _id, params: params);
    var jsonEncodedBody = jsonEncode(message.toJson());
    var contentLengthHeader = 'Content-Length: ${jsonEncodedBody.length}';
    var messagePayload = '$contentLengthHeader\r\n\r\n$jsonEncodedBody';
    AppLogger.instance.debug(messagePayload);
    _csharpProcess?.stdin.write(messagePayload);
    return _sdkResponseCompleter!.future;
  }

  Future<IcaraSdkMessageResponse?> saveRiskInputs(
      BuildContext context, List<String> cellValues) async {
    try {
      await callMethod('SaveRiskInputs', [cellValues]).then((value) {
        AppLogger.instance.debug(value.toJson());
        if (value.result == "Success") {
          SnackbarHolder.showSnackbar(
            "Risk inputs saved successfully",
            false,
            locator<NavigationService>().navigatorKey.currentContext ?? context,
          );
          return value;
        } else {
          SnackbarHolder.showSnackbar(
            "Risk inputs couldn't be saved:${value.result}",
            true,
            locator<NavigationService>().navigatorKey.currentContext ?? context,
          );
          return null;
        }
      });
    } on Exception catch (error, stackTrace) {
      AppLogger.instance.error(error, stackTrace);
      SnackbarHolder.showSnackbar(
        "Risk inputs couldn't be saved",
        true,
        locator<NavigationService>().navigatorKey.currentContext ?? context,
      );
      return null;
    }
    return null;
  }

  Future<IcaraSdkMessageResponse?> saveCorrelationInputs(
      BuildContext context, List<String> cellValues) async {
    return null;
  }
}
