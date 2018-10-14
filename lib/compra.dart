import 'package:flutter/material.dart';

import 'listProdutos.dart';

class CompraPage extends StatefulWidget {
  _CompraPageState createState() => _CompraPageState();
}

class _CompraPageState extends State<CompraPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/carrinho'),
        child: Icon(Icons.shopping_cart),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: ListProdutos(),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Produtos'),
      ),
    );
  }
}
