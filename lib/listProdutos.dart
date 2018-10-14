import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import 'produto.dart';

class ListProdutos extends StatefulWidget {
  static List<Produto> list = List<Produto>();
  _ListProdutosState createState() => _ListProdutosState();
}

class _ListProdutosState extends State<ListProdutos> {
  @override
  void initState() {
    _loadList();
    super.initState();
  }

  void _loadList() async {
    MySqlConnection msc;

    try {
      msc = await MySqlConnection.connect(
        ConnectionSettings(
            host: 'den1.mysql3.gear.host',
            port: 3306,
            user: 'comanda',
            password: 'Fy1p~Z3r9!Rv',
            db: 'comanda'),
      );

      Results result = await msc.query('select * from produto');

      result.forEach((_) {
        setState(() {
          ListProdutos.list.add(Produto(
            uid: _[0],
            nome: _[1],
            desc: _[2],
            valor: _[3],
          ));
        });
      });
    } catch (e) {
      print(e.toString());
    } finally {
      ListProdutos.list.sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
      msc.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: ListProdutos.list,
        )
      ],
    );
  }
}
