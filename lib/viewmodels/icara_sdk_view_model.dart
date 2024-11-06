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
import 'package:path_provider/path_provider.dart';

class IcarasdkViewModel extends ChangeNotifier {
  int _id = 0;

  bool _isLoading = false;
  get isLoading => _isLoading;

  bool _isSdkStarted = false;

  Process? _csharpProcess;

  Completer<IcaraSdkMessageResponse>? _sdkResponseCompleter;

  init(BuildContext context) async {
    // await initiateSdkFolder();
    // if (!_isSdkStarted) {
    //   try {
    //     String? serviceExecutable = await Preferences.getSdkLocation();
    //     if (serviceExecutable == null || serviceExecutable.isEmpty) {
    //       serviceExecutable = await _pickSdkFile();
    //       await Preferences.setSdkLocation(serviceExecutable);
    //     }
    //     _csharpProcess = await Process.start(serviceExecutable ?? "", []);
    //     _csharpProcess?.stdout.listen(_onDataReceived);
    //     _isSdkStarted = true;
    //   } on Exception catch (e, stackTrace) {
    //     AppLogger.instance.error(e, stackTrace);
    //     SnackbarHolder.showSnackbar(
    //       "An error happened while starting the sdk",
    //       true,
    //       locator<NavigationService>().navigatorKey.currentContext ?? context,
    //     );
    //   }
    // }
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

  Future initiateSdkFolder() async {
    // Get the documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Create the folder path
    final folderPath = Directory('${directory.path}/ICARASdk');

    // Check if the folder already exists
    if (await folderPath.exists()) {
      AppLogger.instance
          .debug("SDK folder already exists. Clearing it's content...");
      final List<FileSystemEntity> entities =
          Directory('${directory.path}/ICARASdk').listSync();

      // Loop through each entity and delete it
      for (var entity in entities) {
        try {
          if (entity is File) {
            await entity.delete();
          } else if (entity is Directory) {
            await entity.delete(recursive: true);
          }
          AppLogger.instance.debug("Cleared content within SDK folder.");
        } on Exception catch (e, stackTrace) {
          AppLogger.instance.error(e, stackTrace);
        }
      }
    } else {
      // If it doesn't exist, create it
      await folderPath.create();
      AppLogger.instance.debug("Sdk folder created: ${folderPath.path}");
    }
  }

  dynamic _onDataReceived(event) {
    var strMessage = utf8.decode(event);
    if (strMessage == 'Icara SDK started\r\n') {
      AppLogger.instance.debug("ICARA SDK initiated and ready...");
    } else if (strMessage.startsWith('Content-Length')) {
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
      AppLogger.instance.debug(strMessage);
    }
  }

  Future<IcaraSdkMessageResponse> callMethod(
      String method, List? params) async {
    _sdkResponseCompleter = Completer();
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
      BuildContext context,
      List<String> cellValues,
      int numRisks,
      bool checkBox1,
      bool corBetweenSevs,
      bool corBetweenFreq,
      bool corBetweenFreqAndSev) async {
    try {
      await callMethod(
        'SaveCorrelationMatrixAsync',
        [
          cellValues,
          numRisks,
          checkBox1,
          corBetweenSevs,
          corBetweenFreq,
          corBetweenFreqAndSev,
        ],
      ).then((value) {
        if (value.result == "Success") {
          SnackbarHolder.showSnackbar(
            "Correlations saved successfully",
            false,
            locator<NavigationService>().navigatorKey.currentContext ?? context,
          );
          return value;
        } else {
          SnackbarHolder.showSnackbar(
            "Correlations couldn't be saved:${value.result}",
            true,
            locator<NavigationService>().navigatorKey.currentContext ?? context,
          );
          return null;
        }
      });
    } on Exception catch (e, stacktrace) {
      AppLogger.instance.error(e, stacktrace);
      SnackbarHolder.showSnackbar("Correlation inputs couldn't be saved", true,
          locator<NavigationService>().navigatorKey.currentContext ?? context);
      return null;
    }
    return null;
  }

  Future<IcaraSdkMessageResponse?> runSimulation(
    BuildContext context,
    bool tCapula,
    String cmdUserDefined,
    int noTrials,
    int seed, {
    Map<String, dynamic>? insuranceParameters,
    double? rarocExpectedReturn = 1000000,
  }) async {
    try {
      var businessUnits = await Preferences.getBucketCategories(
          Preferences.BUCKET_1_CATEGORIES);
      var riskUnits = await Preferences.getBucketCategories(
          Preferences.BUCKET_2_CATEGORIES);
      var modelAssumptions = await Preferences.getModelAssumptions();
      int degreesOfFreedom = await Preferences.getDegreesOfFreedom();
      insuranceParameters ??= {
        'excess': 5000000,
        'limit_of_indemnity': 15000000
      };
      await callMethod('RunSimulationAsync', [
        tCapula,
        cmdUserDefined,
        noTrials,
        seed,
        businessUnits,
        riskUnits,
        modelAssumptions,
        degreesOfFreedom,
        insuranceParameters,
        rarocExpectedReturn,
      ]).then((value) {
        if (value.result == "Success") {
          SnackbarHolder.showSnackbar(
            "Simulation run successfull",
            false,
            locator<NavigationService>().navigatorKey.currentContext ?? context,
          );
          return value;
        } else {
          SnackbarHolder.showSnackbar(
            "An error happened while running the simulation: ${value.result}",
            true,
            locator<NavigationService>().navigatorKey.currentContext ?? context,
          );
          return null;
        }
      });
    } on Exception catch (error, stackTrace) {
      AppLogger.instance.error(error, stackTrace);
      SnackbarHolder.showSnackbar(
        "An error happened while running the simulation",
        true,
        locator<NavigationService>().navigatorKey.currentContext ?? context,
      );
      return null;
    }
    return null;
  }

  Future<List<String>?> readFileLines(
      BuildContext context, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      var targetFile = File("${directory.path}/ICARASdk/$fileName");
      return await targetFile.readAsLines();
    } on Exception catch (error, stackTrace) {
      AppLogger.instance.error(error, stackTrace);
      SnackbarHolder.showSnackbar(
        "An error occured while reading the file. Either the file doesn't exist or the application doesn't have the permissions to access the file.",
        true,
        locator<NavigationService>().navigatorKey.currentContext ?? context,
      );
      return null;
    }
  }
}
