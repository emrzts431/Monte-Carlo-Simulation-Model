import 'dart:io';
import 'dart:typed_data';

// import 'package:ICARA/pages/risk_inputs.dart';
import 'package:ICARA/widgets/navigation_drawer.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CapitalModeling extends StatefulWidget {
  const CapitalModeling({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CapitalModelingState();
  }
}

class _CapitalModelingState extends State<CapitalModeling> {
  int _currentIndex = 0; // Variable to track the selected content
  List<List<dynamic>> _rows = []; // Store the Excel rows
  List<Data?> _columnNames = []; // Column names
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Capital Modelling'),
        backgroundColor: Colors.white,
      ),
      drawer: const CustomNavigationDrawer(),
      body: Column(
        children: [
          // Buttons at the top
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                child: const Text('Risk Inputs'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                child: const Text('Validation'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                child: Text('Correlation Inputs'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
                child: Text('Simulation'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
                child: Text('Detailed Report'),
              ),
            ],
          ),
          // Dynamic content based on the button clicked
          Expanded(
            child: _getContentWidget(),
          ),
        ],
      ),
    );
  }

  // Widget to build the Excel Viewer
  Widget _riskInputs() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: _pickExcelFile,
                  child: const Text('Import Excel'),
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: _clearRisks,
                  child: const Text('Clear Risks'),
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: _saveRisks,
                  child: const Text('Save Risks'),
                ),
              ),
            ],
          ),
          Expanded(
            child: _rows.isEmpty
                ? const Center(child: Text('No Data Loaded'))
                : Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 3,
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        DataTable(
                          columns: _rows.isNotEmpty
                              ? List.generate(
                                  _rows[0].length,
                                  (index) => DataColumn(
                                    label: Text(
                                      '${_columnNames[index]!.value}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : [],
                          rows: _rows.isNotEmpty
                              ? List.generate(
                                  _rows.length,
                                  (index) => DataRow(
                                    cells: List.generate(
                                      _rows[index].length,
                                      (cellIndex) => DataCell(
                                        Text(
                                            _rows[index][cellIndex].toString()),
                                      ),
                                    ),
                                  ),
                                )
                              : [],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
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
      print(table); // Sheet name
      print(excel.tables[table]?.maxColumns);
      print(excel.tables[table]?.maxRows);
      if (excel.tables[table]?.maxColumns != 0) {
        _columnNames = excel.tables[table]!.rows[0];
        for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
          List<dynamic> customRow = [];
          for (var cell in excel.tables[table]!.rows[i]) {
            cell != null ? customRow.add(cell.value) : debugPrint("Null Value");
          }
          if (!customRow.contains(null)) {
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
    //TODO: Here we fucking go!
  }

  // Method to return content based on the selected index
  Widget _getContentWidget() {
    switch (_currentIndex) {
      case 0:
        return _riskInputs(); // Default Excel Viewer content
      case 1:
        return const Center(child: Text('Content of Tab 1'));
      case 2:
        return const Center(child: Text('Content of Tab 2'));
      case 3:
        return const Center(child: Text('Content of Tab 3'));
      default:
        return _riskInputs();
    }
  }
}
