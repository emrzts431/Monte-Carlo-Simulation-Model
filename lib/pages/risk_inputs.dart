import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RiskInputs extends StatefulWidget {
  @override
  _RiskInputsState createState() => _RiskInputsState();
}

class _RiskInputsState extends State<RiskInputs> {
  List<List<dynamic>> _rows = [];

  Future<void> _pickExcelFile() async {
    // Allow the user to pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'], // Only allow Excel files
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes != null) {
        _readExcel(fileBytes);
      }
    }
  }

  void _readExcel(Uint8List fileBytes) {
    var excel = Excel.decodeBytes(fileBytes);
    List<List<dynamic>> rows = [];

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        rows.add(row);
      }
    }

    setState(() {
      _rows = rows; // Update the rows with data from the Excel file
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickExcelFile,
          child: Text('Pick Excel File'),
        ),
        Expanded(
          child: _rows.isEmpty
              ? Center(child: Text('No Data Loaded'))
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
    );
  }
}
