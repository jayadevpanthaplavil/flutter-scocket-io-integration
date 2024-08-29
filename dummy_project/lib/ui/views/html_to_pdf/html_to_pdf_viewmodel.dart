import 'dart:io';
import 'package:stacked/stacked.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class HtmlToPdfViewModel extends BaseViewModel {
  final htmlContent = '''
  <h1>Heading Example</h1>
  <p>This is a paragraph.</p>
  <img src="image.jpg" alt="Example Image" />
  <blockquote>This is a quote.</blockquote>
  <ul>
    <li>First item</li>
    <li>Second item</li>
    <li>Third item</li>
  </ul>
''';


  createDocument() async {
    final directory = await getExternalStorageDirectory();
    final downloadsDirectory = Directory('/storage/emulated/0/Download');
    final filePath = path.join(downloadsDirectory.path, 'example.pdf');
    final file = File(filePath);
    final newpdf = Document();
    final List<Widget> widgets = await HTMLToPdf().convert(
      htmlContent,
    );

    newpdf.addPage(MultiPage(
        maxPages: 200,
        build: (context) {
          return widgets;
        }));
    await file.writeAsBytes(await newpdf.save());
    print(filePath);
  }
}
