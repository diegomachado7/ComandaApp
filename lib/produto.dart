import 'package:flutter/material.dart';
import 'package:money/money.dart';

import 'itemCarrinho.dart';

class Produto extends StatelessWidget {
  final int uid;
  final String nome, desc;
  final double valor;

  static List<Produto> listaProduto = List<Produto>();

  const Produto({Key key, this.uid, this.nome, this.desc, this.valor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var m = Money.fromDouble(valor, Currency('BRL'));

    return Card(
      child: FlatButton(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _buildText(s: nome, ts: TextStyle(fontSize: 30.0)),
                ),
                _buildText(
                    s: 'R\$ ' + m.amountAsString, ts: TextStyle(fontSize: 30.0))
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _buildText(
                    s: desc,
                    ts: TextStyle(fontSize: 15.0),
                  ),
                ),
              ],
            )
          ],
        ),
        onPressed: () => listaProduto.add(this),
      ),
    );
  }

  Widget _buildText({String s, TextStyle ts}) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        s,
        style: ts,
      ),
    );
  }
}
