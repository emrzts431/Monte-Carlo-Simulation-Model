import 'dart:io';
import 'dart:typed_data';

import 'package:ICARA/data/preferences.dart';
import 'package:ICARA/viewmodels/icara_sdk_view_model.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class PickRisksContent extends StatefulWidget {
  const PickRisksContent({super.key});

  @override
  State<StatefulWidget> createState() {
    return PickRisksContentState();
  }
}

class PickRisksContentState extends State<PickRisksContent> {
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
      setState(() {});
    });
    super.initState();
  }

  _formatNumber(String value) {
    if (value.isEmpty) return '';

    final number = int.tryParse(value);
    if (number == null) return value;

    final formattedValue = NumberFormat('#,###', 'de_DE').format(number);

    return formattedValue;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
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
                    onPressed: _clearRisks,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                      side: const BorderSide(color: Colors.black, width: 2),
                      elevation: 0,
                    ),
                    child: Text(
                      'Clear Risks',
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
                          onPressed: _saveRisks,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            side:
                                const BorderSide(color: Colors.black, width: 2),
                            elevation: 0,
                          ),
                          child: Text(
                            'Save Risks',
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            context.read<IcarasdkViewModel>().rowsRiskInputs.isEmpty
                ? const Center(child: Text('No Data Loaded'))
                : Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Scrollbar(
                          thumbVisibility: true,
                          trackVisibility: true,
                          thickness: 10,
                          controller: _scrollController,
                          child: Center(
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                border: TableBorder.all(
                                    color: Colors.black, width: 1),
                                // columnWidths: {
                                //   for (var index = 0;
                                //       index < _columnNames.length;
                                //       index++)
                                //     index: const IntrinsicColumnWidth()
                                // },
                                columns: context
                                    .read<IcarasdkViewModel>()
                                    .columnNamesRisks
                                    .map(
                                      (c) => DataColumn(
                                        label: Text(
                                          c,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                rows: [
                                  ...context
                                      .read<IcarasdkViewModel>()
                                      .rowsRiskInputs
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int rowIndex = entry.key;
                                    List<dynamic> row = entry.value;

                                    return DataRow(
                                      cells:
                                          row.asMap().entries.map((cellEntry) {
                                        int cellIndex = cellEntry.key;
                                        String cellContent =
                                            cellEntry.value.toString();

                                        if (context
                                                        .read<IcarasdkViewModel>()
                                                        .columnNamesRisks[
                                                    cellIndex] ==
                                                'K-Factors' ||
                                            context
                                                        .read<IcarasdkViewModel>()
                                                        .columnNamesRisks[
                                                    cellIndex] ==
                                                'Loss Types') {
                                          List<String> dropdownItems = [];

                                          if (context
                                                      .read<IcarasdkViewModel>()
                                                      .columnNamesRisks[
                                                  cellIndex] ==
                                              'K-Factors') {
                                            dropdownItems = _kfactors;
                                          } else if (context
                                                      .read<IcarasdkViewModel>()
                                                      .columnNamesRisks[
                                                  cellIndex] ==
                                              'Loss Types') {
                                            dropdownItems = _lossTypes;
                                          }

                                          String? dropdownValue = dropdownItems
                                                  .contains(cellContent)
                                              ? cellContent
                                              : null;

                                          return DataCell(
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                  maxWidth: 150,
                                                ),
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  focusColor: Colors.white,
                                                  value: dropdownValue,
                                                  items: dropdownItems
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      context
                                                                  .read<
                                                                      IcarasdkViewModel>()
                                                                  .rowsRiskInputs[
                                                              rowIndex][
                                                          cellIndex] = newValue;
                                                    });
                                                  },
                                                  decoration:
                                                      const InputDecoration(
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                  maxWidth: 150,
                                                ),
                                                child: TextFormField(
                                                  initialValue: _formatNumber(
                                                        cellContent,
                                                      ) ??
                                                      '',
                                                  textAlign: TextAlign.center,
                                                  decoration:
                                                      const InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0),
                                                    border: InputBorder.none,
                                                  ),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      String formattedValue =
                                                          _formatNumber(
                                                                newValue,
                                                              ) ??
                                                              '';

                                                      context
                                                                  .read<
                                                                      IcarasdkViewModel>()
                                                                  .rowsRiskInputs[
                                                              rowIndex][cellIndex] =
                                                          formattedValue;
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
                  ),
          ],
        ),
      ),
    );
  }

  // Method to pick and read an Excel file
  Future<void> _pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (result != null) {
      var filePath = result.files.first.path;
      Uint8List? fileBytes = await File(filePath ?? "").readAsBytes();
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
        context.read<IcarasdkViewModel>().columnNamesRisks = excel
            .tables[table]!.rows[0]
            .map((d) => d!.value.toString())
            .toList();
        context.read<IcarasdkViewModel>().columnNamesRisks.insert(0, "Risk No");
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
      context.read<IcarasdkViewModel>().rowsRiskInputs = rows;
    });
  }

  void _clearRisks() {
    setState(() {
      context.read<IcarasdkViewModel>().columnNamesRisks = [];
      context.read<IcarasdkViewModel>().rowsRiskInputs = [];
    });
  }

  Future _saveRisks() async {
    final List<String> cellValues = [];
    for (var row in context.read<IcarasdkViewModel>().rowsRiskInputs) {
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
