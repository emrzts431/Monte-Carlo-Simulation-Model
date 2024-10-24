import 'dart:io';
import 'dart:typed_data';

import 'package:ICARA/pages/risk_inputs.dart';
import 'package:ICARA/widgets/navigation_drawer.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CapitalModeling extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CapitalModelingState();
  }
}

class _CapitalModelingState extends State<CapitalModeling> {
  int _currentIndex = 0; // Variable to track the selected content
  List<List<dynamic>> _rows = []; // Store the Excel rows

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
      print(table); //sheet Name
      print(excel.tables[table]?.maxColumns);
      print(excel.tables[table]?.maxRows);
      for (var row in excel.tables[table]!.rows) {
        List<dynamic> customRow = [];
        for (var cell in row) {
          cell != null ? customRow.add(cell.value) : debugPrint("Null Value");
        }
        rows.add(customRow);
      }
    }

    setState(() {
      _rows = rows;
    });
  }

  // Method to return content based on the selected index
  Widget _getContentWidget() {
    switch (_currentIndex) {
      case 0:
        return _buildExcelViewer(); // Default Excel Viewer content
      case 1:
        return Center(child: Text('Content of Tab 1'));
      case 2:
        return Center(child: Text('Content of Tab 2'));
      case 3:
        return Center(child: Text('Content of Tab 3'));
      default:
        return _buildExcelViewer();
    }
  }

  // Widget to build the Excel Viewer
  Widget _buildExcelViewer() {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _pickExcelFile,
            child: const Text('Import Excel'),
          ),
          Expanded(
            child: _rows.isEmpty
                ? const Center(child: Text('No Data Loaded'))
                : ListView.builder(
                    itemCount: _rows.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_rows[index].join(', ')),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Capital Modelling'),
        backgroundColor: Colors.white,
      ),
      drawer: CustomNavigationDrawer(),
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
                child: Text('Excel Viewer'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                child: Text('Tab 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                child: Text('Tab 2'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
                child: Text('Tab 3'),
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
}
