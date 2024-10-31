import 'dart:io';
import 'dart:typed_data';

import 'package:ICARA/data/preferences.dart';
import 'package:ICARA/services/navigation_service.dart';
import 'package:ICARA/services/service_locator.dart';
import 'package:ICARA/viewmodels/icara_sdk_view_model.dart';
import 'package:ICARA/widgets/snackbar_holder.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PickRisksContent extends StatefulWidget {
  const PickRisksContent({super.key});

  @override
  State<StatefulWidget> createState() {
    return PickRisksContentState();
  }
}

class PickRisksContentState extends State<PickRisksContent> {
  final _logger = Logger(
    printer: PrettyPrinter(methodCount: 1),
  );
  List<List<dynamic>> _rows = [];
  List<String> _columnNames = [];
  List<String> _kfactors = [];
  List<String> _lossTypes = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      _kfactors = await Preferences.getBucketCategories(
          Preferences.BUCKET_1_CATEGORIES);
      _lossTypes = await Preferences.getBucketCategories(
          Preferences.BUCKET_2_CATEGORIES);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: _pickExcelFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                    side: const BorderSide(color: Colors.black, width: 2),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Import Excel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: _clearRisks,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                    side: const BorderSide(color: Colors.black, width: 2),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Clear Risks',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: context.watch<IcarasdkViewModel>().isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: _saveRisks,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          overlayColor: Colors.transparent,
                          side: const BorderSide(color: Colors.black, width: 2),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Save Risks',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          _rows.isEmpty
              ? const Center(child: Text('No Data Loaded'))
              : Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Scrollbar(
                        thumbVisibility: true,
                        trackVisibility: true,
                        thickness: 10,
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            border:
                                TableBorder.all(color: Colors.black, width: 1),
                            // columnWidths: {
                            //   for (var index = 0;
                            //       index < _columnNames.length;
                            //       index++)
                            //     index: const IntrinsicColumnWidth()
                            // },
                            columns: _columnNames
                                .map(
                                  (c) => DataColumn(
                                    label: Text(
                                      c,
                                    ),
                                  ),
                                )
                                .toList(),
                            rows: [
                              ..._rows.asMap().entries.map((entry) {
                                int rowIndex = entry.key;
                                List<dynamic> row = entry.value;

                                return DataRow(
                                  cells: row.asMap().entries.map((cellEntry) {
                                    int cellIndex = cellEntry.key;
                                    String cellContent =
                                        cellEntry.value.toString();

                                    if (_columnNames[cellIndex] ==
                                            'K-Factors' ||
                                        _columnNames[cellIndex] ==
                                            'Loss Types') {
                                      List<String> dropdownItems = [];

                                      if (_columnNames[cellIndex] ==
                                          'K-Factors') {
                                        dropdownItems = _kfactors;
                                      } else if (_columnNames[cellIndex] ==
                                          'Loss Types') {
                                        dropdownItems = _lossTypes;
                                      }

                                      String? dropdownValue =
                                          dropdownItems.contains(cellContent)
                                              ? cellContent
                                              : null;

                                      return DataCell(
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            constraints: const BoxConstraints(
                                              maxWidth: 150,
                                            ),
                                            child:
                                                DropdownButtonFormField<String>(
                                              focusColor: Colors.white,
                                              value: dropdownValue,
                                              items: dropdownItems
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _rows[rowIndex][cellIndex] =
                                                      newValue;
                                                });
                                              },
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return DataCell(
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            constraints: const BoxConstraints(
                                              maxWidth: 150,
                                            ),
                                            child: TextFormField(
                                              initialValue: cellContent,
                                              textAlign: TextAlign.center,
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                border: InputBorder.none,
                                              ),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _rows[rowIndex][cellIndex] =
                                                      newValue;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }).toList(),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Method to pick and read an Excel file
  Future<void> _pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );
    if (result != null) {
      var filePath = result.files.first.path;
      Uint8List? fileBytes = File(filePath ?? "").readAsBytesSync();
      _readExcel(fileBytes);
    }
  }

  void _readExcel(Uint8List fileBytes) {
    var excel = Excel.decodeBytes(fileBytes);
    List<List<dynamic>> rows = [];

    for (var table in excel.tables.keys) {
      // print(table); // Sheet name
      // print(excel.tables[table]?.maxColumns);
      // print(excel.tables[table]?.maxRows);
      if (excel.tables[table]?.maxColumns != 0) {
        _columnNames = excel.tables[table]!.rows[0]
            .map((d) => d!.value.toString())
            .toList();
        _columnNames.insert(0, "Risk No");
        for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
          List<dynamic> customRow = [];
          for (var cell in excel.tables[table]!.rows[i]) {
            cell != null && cell.value != null
                ? customRow.add(cell.value)
                : debugPrint("Null Value");
          }
          if (customRow.isNotEmpty && !customRow.contains(null)) {
            customRow.insert(0, "Risk $i");
            rows.add(customRow);
          }
        }
      }
    }

    setState(() {
      _rows = rows;
    });
  }

  void _clearRisks() {
    setState(() {
      _columnNames = [];
      _rows = [];
    });
  }

  Future _saveRisks() async {
    final List<String> cellValues = [];
    for (var row in _rows) {
      for (var cell in row) {
        cellValues.add(cell.toString());
      }
    }

    await context.read<IcarasdkViewModel>().saveRiskInputs(
          context,
          cellValues,
        );
  }
}
