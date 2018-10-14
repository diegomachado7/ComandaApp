import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class RegisterPage extends StatefulWidget {
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passwdController = TextEditingController();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cartaoController = TextEditingController();

  bool _loading = false;
  bool _passwordVisibilty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: IgnorePointer(
              ignoring: _loading,
              child: Column(
                children: <Widget>[
                  _buildTextField(
                      controller: _nameController,
                      labelText: 'Nome',
                      keyboardType: TextInputType.text,
                      filled: true,
                      prefixIcon: Icon(Icons.face)),
                  _buildTextField(
                      controller: _cpfController,
                      labelText: 'CPF',
                      keyboardType: TextInputType.text,
                      filled: true,
                      prefixIcon: Icon(Icons.perm_identity)),
                  _buildTextField(
                      controller: _cartaoController,
                      labelText: 'Cartão de crédito',
                      keyboardType: TextInputType.text,
                      filled: true,
                      prefixIcon: Icon(Icons.credit_card)),
                  _buildTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      filled: true,
                      prefixIcon: Icon(Icons.mail)),
                  _buildTextField(
                      controller: _passwdController,
                      isPassword: !_passwordVisibilty,
                      labelText: 'Senha',
                      keyboardType: TextInputType.text,
                      filled: true,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        tooltip: _passwordVisibilty
                            ? 'Esconder senha'
                            : 'Mostrar senha',
                        icon: Icon(_passwordVisibilty
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(
                            () => _passwordVisibilty = !_passwordVisibilty),
                      )),
                  RaisedButton(
                    child: Text('Gravar'),
                    onPressed: () => _register(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController controller,
    bool autocorrect = false,
    bool isPassword = false,
    bool filled = false,
    Icon icon,
    Icon prefixIcon,
    Widget suffixIcon,
    EdgeInsetsGeometry contentPadding,
    Key key,
    TextInputType keyboardType = TextInputType.text,
    String labelText,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        autocorrect: autocorrect,
        decoration: InputDecoration(
          contentPadding: contentPadding,
          labelText: labelText,
          filled: filled,
          prefixIcon:
              Padding(child: prefixIcon, padding: EdgeInsets.only(right: 10.0)),
          icon: icon,
          suffixIcon: suffixIcon,
        ),
        key: key,
        keyboardType: keyboardType,
        obscureText: isPassword,
      ),
    );
  }

  void _register() async {
    setState(() => _loading = true);

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

      var result = await msc.query(
          'insert into user (email, senha, nome, cpf, cartao) values (?, ?, ?, ?, ?)',
          [
            _emailController.text,
            _passwdController.text,
            _nameController.text,
            _cpfController.text,
            _cartaoController.text
          ]);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(result.affectedRows > 0
            ? 'Usuário cadastrado com sucesso!'
            : 'Não foi possivel cadastrar!'),
      ));
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    } finally {
      msc.close();
      Timer(Duration(seconds: 1), () => Navigator.pop(context));
    }
  }
}
