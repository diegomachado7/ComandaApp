import 'package:flutter/material.dart';
import 'package:money/money.dart';

class ItemCarrinho extends StatelessWidget {
  final int uid;
  final String nome, desc;
  final double valor;
  final int qtd;

  static List<ItemCarrinho> listaCarrinho = List<ItemCarrinho>();

  const ItemCarrinho(
      {Key key, this.uid, this.nome, this.desc, this.valor, this.qtd})
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
                  child: _buildText(
                      s: '$qtd\t $nome', ts: TextStyle(fontSize: 30.0)),
                ),
                _buildText(
                    s: 'R\$ ' + (m * qtd).amountAsString,
                    ts: TextStyle(fontSize: 30.0))
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
        onPressed: () => listaCarrinho.removeWhere((_) => _.uid == uid),
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
