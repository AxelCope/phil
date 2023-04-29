
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

void main()
{
  runApp(ExcelTest());
}

class ExcelTest extends StatefulWidget {
  const ExcelTest({Key? key}) : super(key: key);

  @override
  State<ExcelTest> createState() => _ExcelTestState();
}

class _ExcelTestState extends State<ExcelTest> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: Button(
          child: const Text("Envoyez les inactifs"),
          onPressed: () => GenerateExcel(),
        ),
      ),
    );
  }

  Future<void> GenerateExcel()
  async{
    List<String> ok = [
      "id"
    ];
    // Create a new Excel document.
    final Workbook workbook = new Workbook();
//Accessing worksheet via index.
    final Worksheet sheet = workbook.worksheets[0];
//Add Text.
    sheet.getRangeByName('A1').setText('Hello World');
//Add Number
// Save the document.
    final List<int> bytes = workbook.saveAsStream();
    //File('AddingTextNumberDateTime.xlsx').writeAsBytes(bytes);
//Dispose the workbook.
    workbook.dispose();

    File("MyExcellllTest.xlsx");

    final String path = ( await getApplicationSupportDirectory()).path;
    final String filename = Platform.isWindows?'$path\\MonFIFIExcel.xlsx' : '$path/MonFIFIExcel.xlsx';
    final File file = File(filename);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(filename);
  }


}
