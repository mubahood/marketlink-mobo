import 'package:flutter/material.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/Utils.dart';
import 'package:flutx/widgets/text/text.dart';

/// Represents PdfViewerScreen for Navigation
class PdfViewerScreen extends StatefulWidget {
  String url, title;

  PdfViewerScreen(
    this.url,
    this.title,
  );

  @override
  _PdfViewerScreen createState() => _PdfViewerScreen();
}

class _PdfViewerScreen extends State<PdfViewerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        centerTitle: false,
        title: FxText.titleLarge(
          widget.title,
          fontSize: 20,
          fontWeight: 900,
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download,
                color: Colors.white, size: 35.0, semanticLabel: 'Download PDF'),
            onPressed: () {
              //_pdfViewerKey.currentState?.openBookmarkView();
              Utils.urlLauncher(
                widget.url,
                title: 'Download PDF',
              );
            },
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: Text("as"),
    );
  }
}
