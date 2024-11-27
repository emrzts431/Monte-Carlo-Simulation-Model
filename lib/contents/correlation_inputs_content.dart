import 'dart:io';
import 'dart:typed_data';

import 'package:ICARA/viewmodels/icara_sdk_view_model.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CorrelationInputsContent extends StatefulWidget {
  const CorrelationInputsContent({super.key});

  @override
  State<StatefulWidget> createState() {
    return CorrelationInputsContentState();
  }
}

class CorrelationInputsContentState extends State<CorrelationInputsContent> {
  final _scrollController = ScrollController();

  List<String> correlationStyles = [
    "Use A Single Correlation",
    "Correlation between Inputs",
    "Correlation Between Likelihoods",
    "Correlation between Likelihoods and Inputs"
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.grey[200],
                  side: const BorderSide(color: Colors.black),
                  label: Text(
                    correlationStyles[0],
                  ),
                  selected: context
                          .read<IcarasdkViewModel>()
                          .selectedCorrelationStyle ==
                      0,
                  onSelected: (bool value) {
                    setState(() {
                      context
                          .read<IcarasdkViewModel>()
                          .selectedCorrelationStyle = 0;
                    });
                  },
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      backgroundColor: context
                                  .read<IcarasdkViewModel>()
                                  .selectedCorrelationStyle ==
                              0
                          ? Colors.grey[300]
                          : Colors.grey[200],
                      side: const BorderSide(color: Colors.black),
                      label: Text(correlationStyles[1]),
                      selected: context
                              .read<IcarasdkViewModel>()
                              .selectedCorrelationStyle ==
                          1,
                      onSelected: (bool value) {
                        setState(() {
                          context
                              .read<IcarasdkViewModel>()
                              .selectedCorrelationStyle = 1;
                        });
                      },
                    ),
                    ChoiceChip(
                      backgroundColor: context
                                  .read<IcarasdkViewModel>()
                                  .selectedCorrelationStyle ==
                              0
                          ? Colors.grey[300]
                          : Colors.grey[200],
                      side: const BorderSide(color: Colors.black),
                      label: Text(correlationStyles[2]),
                      selected: context
                              .read<IcarasdkViewModel>()
                              .selectedCorrelationStyle ==
                          2,
                      onSelected: (bool value) {
                        setState(() {
                          context
                              .read<IcarasdkViewModel>()
                              .selectedCorrelationStyle = 2;
                        });
                      },
                    ),
                    ChoiceChip(
                      backgroundColor: context
                                  .read<IcarasdkViewModel>()
                                  .selectedCorrelationStyle ==
                              0
                          ? Colors.grey[300]
                          : Colors.grey[200],
                      side: const BorderSide(color: Colors.black),
                      label: Text(correlationStyles[3]),
                      selected: context
                              .read<IcarasdkViewModel>()
                              .selectedCorrelationStyle ==
                          3,
                      onSelected: (bool value) {
                        setState(() {
                          context
                              .read<IcarasdkViewModel>()
                              .selectedCorrelationStyle = 3;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
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
                    child: Text(
                      'Import Excel',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    onPressed: _clearCorrelations,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                      side: const BorderSide(color: Colors.black, width: 2),
                      elevation: 0,
                    ),
                    child: Text(
                      'Clear Correlations',
                      style: GoogleFonts.poppins(color: Colors.black),
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
                          onPressed: _saveCorrelations,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            side:
                                const BorderSide(color: Colors.black, width: 2),
                            elevation: 0,
                          ),
                          child: Text(
                            'Save Correlations',
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            context.read<IcarasdkViewModel>().rowsCorrelationInputs.isEmpty
                ? const Center(child: Text('No Data Loaded'))
                : SizedBox(
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
                            columns: context
                                .read<IcarasdkViewModel>()
                                .columnNamesCorrealtionInputs
                                .map(
                                  (c) => DataColumn(
                                    label: Text(
                                      c ?? '',
                                    ),
                                  ),
                                )
                                .toList(),
                            border:
                                TableBorder.all(color: Colors.black, width: 1),
                            rows: [
                              ...context
                                  .read<IcarasdkViewModel>()
                                  .rowsCorrelationInputs
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int rowIndex = entry.key;
                                List<dynamic> row = entry.value;

                                return DataRow(
                                  cells: row.asMap().entries.map((cellEntry) {
                                    int cellIndex = cellEntry.key;
                                    String cellContent =
                                        cellEntry.value.toString();

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
                                                context
                                                        .read<IcarasdkViewModel>()
                                                        .rowsCorrelationInputs[
                                                    rowIndex][cellIndex] = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

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
    String table = 'Sheet1';
    //for (var table in excel.tables.keys) {
    // print(table); // Sheet name
    // print(excel.tables[table]?.maxColumns);
    // print(excel.tables[table]?.maxRows);

    if (excel.tables[table]?.maxColumns != 0) {
      for (var data in excel.tables[table]!.rows[0].toList()) {
        if (data != null && data.value != null) {
          context
              .read<IcarasdkViewModel>()
              .columnNamesCorrealtionInputs
              .add(data.value.toString());
        }
      }
      context
          .read<IcarasdkViewModel>()
          .columnNamesCorrealtionInputs
          .insert(0, "Risk No");
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
    //}

    setState(() {
      context.read<IcarasdkViewModel>().rowsCorrelationInputs = rows;
    });
  }

  void _clearCorrelations() {
    setState(() {
      context.read<IcarasdkViewModel>().columnNamesCorrealtionInputs = [];
      context.read<IcarasdkViewModel>().rowsCorrelationInputs = [];
    });
  }

  Future _saveCorrelations() async {
    final List<String> cellValues = [];
    for (var row in context.read<IcarasdkViewModel>().rowsCorrelationInputs) {
      for (var cell in row) {
        cellValues.add(cell.toString());
      }
    }

    await context.read<IcarasdkViewModel>().saveCorrelationInputs(
          context,
          cellValues,
          context
                  .read<IcarasdkViewModel>()
                  .columnNamesCorrealtionInputs
                  .length -
              1,
          context.read<IcarasdkViewModel>().selectedCorrelationStyle == 0,
          context.read<IcarasdkViewModel>().selectedCorrelationStyle == 1,
          context.read<IcarasdkViewModel>().selectedCorrelationStyle == 2,
          context.read<IcarasdkViewModel>().selectedCorrelationStyle == 3,
        );
  }
}
