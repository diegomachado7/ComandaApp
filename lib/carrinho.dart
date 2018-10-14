import 'package:flutter/material.dart';

import 'produto.dart';
import 'itemCarrinho.dart';

class CarrinhoPage extends StatefulWidget {
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  void _loadList() async {
    Produto tmp = Produto(uid: -1);
    int qtd;

    Produto.listaProduto.forEach((p) {
      if (p.uid != tmp.uid) {
        tmp = p;
        qtd = 0;
      } else if (tmp != null) {
        ItemCarrinho.listaCarrinho.add(ItemCarrinho(
          desc: tmp.desc,
          nome: tmp.nome,
          qtd: qtd,
          uid: tmp.uid,
          valor: tmp.valor,
        ));
      }
      qtd++;
    });
    if (tmp.uid != -1) {
      ItemCarrinho.listaCarrinho.add(ItemCarrinho(
        desc: tmp.desc,
        nome: tmp.nome,
        qtd: qtd,
        uid: tmp.uid,
        valor: tmp.valor,
      ));
    }
  }

  @override
  void initState() {
    _loadList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: ItemCarrinho.listaCarrinho,
            ),
          ),
        ),
      ),
    );
  }
}
