import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:salesapp/services/models.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PDFService {
  final textScaleFactorFooter = 0.7;
  final textScaleFactorHeader = 0.8;
  pw.MemoryImage? _logo;
  Order _order = Order();
  final DateFormat _format = DateFormat('dd.MM.yyyy');
  final NumberFormat _amountFormat =
      NumberFormat.currency(locale: "de_DE", symbol: '€');
  final NumberFormat _percentFormat = NumberFormat.percentPattern("de_DE");

  Future<pw.Document> generatePDF(Order order) async {
    _logo = pw.MemoryImage(
      (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
    );

    _order = order;

    final doc = pw.Document(title: order.orderNr, author: 'NaturGlück');

    doc.addPage(pw.MultiPage(
      pageTheme: _buildTheme(
        await PdfGoogleFonts.robotoRegular(),
        await PdfGoogleFonts.robotoBold(),
        await PdfGoogleFonts.robotoItalic(),
      ),
      header: _buildHeader,
      footer: _buildFooter,
      build: (context) => [
        _contentHeader(context),
        _contentTable(context),
        _contentFooter(context),
      ],
    ));

    return doc;
  }

  void savePDF() async {
    // final output = await getTemporaryDirectory();
    // final file = File("${output.path}/example.pdf");
    // await file.writeAsBytes(await _doc.document.save());
  }

  void printPDF() async {
    // await Printing.layoutPdf(
    //     onLayout: (PdfPageFormat format) async => _doc.document.save());
  }

  PdfPreview showPDF(Future<pw.Document> doc) {
    return PdfPreview(
      build: (format) => doc.then((value) => value.save()),
    );
  }

  pw.PageTheme _buildTheme(pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4.copyWith(
          marginBottom: 0.5 * PdfPageFormat.cm,
          marginLeft: 2.5 * PdfPageFormat.cm,
          marginRight: 2 * PdfPageFormat.cm,
          marginTop: 1 * PdfPageFormat.cm),
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
      ),
    );
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(children: [
      pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Image(_logo!, width: 3.5 * PdfPageFormat.cm),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('NaturGlück Tina Spiegel',
                  textScaleFactor: textScaleFactorHeader),
              pw.Text('Marktplatz 6', textScaleFactor: textScaleFactorHeader),
              pw.Text('97246 Eibelstadt',
                  textScaleFactor: textScaleFactorHeader),
              pw.Text('Tel.: 09303/7279814',
                  textScaleFactor: textScaleFactorHeader),
              pw.Text('blumen@natur-glueck.de',
                  textScaleFactor: textScaleFactorHeader),
              pw.Text('www.natur-glueck.de',
                  textScaleFactor: textScaleFactorHeader),
            ],
          ),
        ),
      ]),
      if (context.pageNumber > 1) pw.SizedBox(height: 20),
    ]);
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 20),
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Expanded(
                  child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('NaturGlück Tina Spiegel',
                      textScaleFactor: textScaleFactorFooter),
                  pw.Text('Marktplatz 6',
                      textScaleFactor: textScaleFactorFooter),
                  pw.Text('97246 Eibelstadt',
                      textScaleFactor: textScaleFactorFooter),
                  pw.Text('Tel.: 09303/7279814',
                      textScaleFactor: textScaleFactorFooter),
                  pw.Text('blumen@natur-glueck.de',
                      textScaleFactor: textScaleFactorFooter),
                  pw.Text('www.natur-glueck.de',
                      textScaleFactor: textScaleFactorFooter),
                ],
              )),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('USt-IdNr.: DE325801657',
                        textScaleFactor: textScaleFactorFooter),
                    pw.Text('Steuernummer: 257/275/51258',
                        textScaleFactor: textScaleFactorFooter),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Tina Spiegel',
                        textScaleFactor: textScaleFactorFooter),
                    pw.Text('N26', textScaleFactor: textScaleFactorFooter),
                    pw.Text('IBAN: DE52 1001 1001 2625 5777 09',
                        textScaleFactor: textScaleFactorFooter),
                    pw.Text('BIC: NTSBDEB1XXX',
                        textScaleFactor: textScaleFactorFooter),
                  ],
                ),
              ),
            ]),
        pw.SizedBox(height: 10),
        pw.Text(
          'Seite ${context.pageNumber}/${context.pagesCount}',
        ),
      ],
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      height: 6 * PdfPageFormat.cm,
      child: pw.Column(children: [
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(
              'NaturGlück Tina Spiegel, Martkplatz 6, 97246 Eibelstadt',
              style: pw.TextStyle.defaultStyle().copyWith(
                  fontSize: 8.0 * PdfPageFormat.point,
                  decoration: pw.TextDecoration.underline),
            ),
            pw.SizedBox(height: 5),
            pw.Text(_order.customer!.name1),
            if (_order.customer!.name2 != '') pw.Text(_order.customer!.name2),
            pw.Text(_order.customer!.street),
            pw.Text(_order.customer!.zipcode + ' ' + _order.customer!.city)
          ]),
          pw.Expanded(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Rechnung', style: pw.Theme.of(context).header1),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text('Rechnungsnr.:'),
                        pw.Container(
                            alignment: pw.Alignment.topRight,
                            width: 75,
                            child: pw.Text(_order.orderNr)),
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text('Kundennr.:'),
                        pw.Container(
                            alignment: pw.Alignment.topRight,
                            width: 75,
                            child: pw.Text(
                                _order.customer!.customerId.toString())),
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text('Datum:'),
                        pw.Container(
                          alignment: pw.Alignment.topRight,
                          width: 75,
                          child: pw.Text(_format.format(_order.orderdate!)),
                        ),
                      ]),
                ]),
          ),
        ]),
        pw.Expanded(
          child: pw.Container(
            alignment: pw.Alignment.bottomLeft,
            child: pw.Text(_order.text, style: pw.Theme.of(context).header1),
          ),
        ),
      ]),
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Pos.',
      'Bezeichnung',
      'Menge',
      'Einzel €',
      'USt. %',
      'Gesamt €'
    ];

    List<pw.Widget> widgets = [];
    List<List<String>> tableData = [];

    for (var i = 0; i < _order.items.length; i++) {
      tableData.add(
        [
          _order.items[i].posnum,
          _order.items[i].text,
          if (_order.items[i].postype == 'normal')
            _order.items[i].quantity.toString(),
          if (_order.items[i].postype == 'normal')
            _amountFormat.format(_order.items[i].amountGross),
          if (_order.items[i].postype == 'normal')
            _percentFormat.format(_order.items[i].vat / 100),
          if (_order.items[i].postype == 'normal')
            _amountFormat.format(_order.items[i].amountTotal),
        ],
      );
      if (tableData.length == 15) {
        pw.Table table = pw.Table.fromTextArray(
          headers: tableHeaders,
          data: tableData,
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.grey400,
          ),
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
          ),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
          },
          columnWidths: {
            0: const pw.FixedColumnWidth(20),
            1: const pw.FixedColumnWidth(100),
            2: const pw.FixedColumnWidth(25),
            3: const pw.FixedColumnWidth(35),
            4: const pw.FixedColumnWidth(25),
            5: const pw.FixedColumnWidth(40),
          },
        );
        widgets.add(pw.Container(
          margin: const pw.EdgeInsets.only(top: 20),
          child: table,
        ));
        tableData.clear();
      }
    }

    tableData.add([
      '',
      'Gesamtbetrag*',
      '',
      '',
      '',
      _amountFormat.format(_order.amountGross),
    ]);

    pw.Table table = pw.Table.fromTextArray(
      headers: tableHeaders,
      data: tableData,
      headerDecoration: const pw.BoxDecoration(
        color: PdfColors.grey400,
      ),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: const pw.FixedColumnWidth(20),
        1: const pw.FixedColumnWidth(100),
        2: const pw.FixedColumnWidth(25),
        3: const pw.FixedColumnWidth(35),
        4: const pw.FixedColumnWidth(25),
        5: const pw.FixedColumnWidth(40),
      },
    );
    widgets.add(pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: table,
    ));

    widgets.add(pw.Container(
        margin: const pw.EdgeInsets.only(top: 20),
        child: pw.Text(
            '* Im Gesamtbetrag von ${_amountFormat.format(_order.amountGross)} (Netto: ${_amountFormat.format(_order.amountNet)}) sind '
            'USt 7 % (${_amountFormat.format(_order.amountVat7)} auf Netto ${_amountFormat.format(_order.amountNet7)}), '
            'USt 19 % (${_amountFormat.format(_order.amountVat19)} auf Netto ${_amountFormat.format(_order.amountNet19)}) enthalten.')));

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: widgets,
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child:
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text('Zahlbar sofort, rein netto'),
        pw.SizedBox(height: 10),
        pw.Text('Liebe Grüße vom NaturGlück'),
        pw.Text('Blumen machen glücklich.'),
        pw.Text('Tina Spiegel'),
      ]),
    );
  }
}
