import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import 'register.dart';
import 'compra.dart';
import 'userClass.dart';
import 'qrcode.dart';
import 'carrinho.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comanda Eletronica',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: 'Café++'),
      initialRoute: '/',
      routes: {
        '/register': (context) => RegisterPage(),
        '/compra': (context) => CompraPage(),
        '/qrcode': (context) => QRReader(),
        '/carrinho': (context) => CarrinhoPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwdController = TextEditingController();
  bool _loading = false;
  bool _passwordVisibilty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: IgnorePointer(
              ignoring: _loading,
              child: Center(
                child: _loginAndPasswd(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginAndPasswd() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
              tooltip: _passwordVisibilty ? 'Esconder senha' : 'Mostrar senha',
              icon: Icon(
                  _passwordVisibilty ? Icons.visibility_off : Icons.visibility),
              onPressed: () =>
                  setState(() => _passwordVisibilty = !_passwordVisibilty),
            ),
          ),
          RaisedButton(
            child: Text('Login'),
            onPressed: _normalLogin,
          ),
          RaisedButton(
              child: Text('Cadastrar'),
              onPressed: () => Navigator.pushNamed(context, '/register')),
          _buildProgressBar(),
        ],
      );

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

  Widget _buildProgressBar() {
    return Opacity(
      opacity: _loading ? 1.0 : 0.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(value: null),
      ),
    );
  }

  void _normalLogin() async {
    MySqlConnection msc;
    Results result, token;

    setState(() => _loading = true);

    try {
      msc = await MySqlConnection.connect(
        ConnectionSettings(
            host: 'den1.mysql3.gear.host',
            port: 3306,
            user: 'comanda',
            password: 'Fy1p~Z3r9!Rv',
            db: 'comanda'),
      );

      result = await msc.query(
          'select userId from user where email = ? and senha = ? and userId != 1',
          [_emailController.text, _passwdController.text]);
      UserClass.uid = result.single[0];
      token = await msc.query(
          'select * from token where userId = ? and ativo != false',
          [UserClass.uid]);
      Navigator.pushReplacementNamed(
          context, token.length >= 0 ? '/compra' : '/qrcode');
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    } finally {
      msc.close();
      setState(() => _loading = false);
    }
  }
}
