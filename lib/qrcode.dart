import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:mysql1/mysql1.dart';

import 'userClass.dart';

class QRReader extends StatefulWidget {
  _RrReaderState createState() => _RrReaderState();
}

class _RrReaderState extends State<QRReader> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QRCode Scanner'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Você não está registrado em nenhum lugar!',
                  style: TextStyle(fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text('Escanear QR Code'),
                    onPressed: _scan,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _scan() async {
    MySqlConnection msc;
    try {
      String barcode = await BarcodeScanner.scan();

      msc = await MySqlConnection.connect(
        ConnectionSettings(
            host: 'den1.mysql3.gear.host',
            port: 3306,
            user: 'comanda',
            password: 'Fy1p~Z3r9!Rv',
            db: 'comanda'),
      );

      var token = await msc.query('select tokenId where qr = ?', [barcode]);
      if (token.length == 0) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Este QR Code não é valido!'),
        ));
      } else {
        msc.query('update Token set userId = ?, ativo = true', [UserClass.uid]);
        msc.close();
        Navigator.pushReplacementNamed(context, '/compra');
      }
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    } finally {
      msc.close();
    }
  }
}
