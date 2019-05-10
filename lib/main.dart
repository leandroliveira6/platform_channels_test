import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String titulo = 'Testes com EventChannel';
    return MaterialApp(
      title: titulo,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: titulo),
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
  EventChannel _canalDeEventoTeste = EventChannel('testeEvento');
  MethodChannel _canalDeMetodoTeste = MethodChannel('testeMetodo');
  StreamSubscription _escutaTeste;
  int _valor = 0;
  String _mensagem = '';

  void _iniciarEscuta() {
    if (_escutaTeste == null) {
      _escutaTeste =
          _canalDeEventoTeste.receiveBroadcastStream().listen(_atualizarEscuta);
    }
  }

  void _cancelarEscuta() {
    if (_escutaTeste != null) {
      _escutaTeste.cancel();
      _escutaTeste = null;
    }
  }

  void _atualizarEscuta(valor) {
    debugPrint("Timer $valor");
    setState(() => _valor = valor);
  }

  void _obterMensagem() async {
    await _canalDeMetodoTeste.invokeMethod(
        'metodo', <String, dynamic>{'data': 'Le'}).then((result) {
      print(result);
      setState(() {
        _mensagem = result;
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Container(
          padding: new EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              _obterCard(
                'Contador de segundos',
                'Um exemplo simples do uso do event channel.',
                '$_valor',
                [
                  FlatButton(
                    child: const Text('Iniciar escuta'),
                    onPressed: _iniciarEscuta,
                  ),
                  FlatButton(
                    child: const Text('Cancelar escuta'),
                    onPressed: _cancelarEscuta,
                  ),
                ]
              ),
              _obterCard(
                'Obter uma saudacao com o numero de segundos atual',
                'Um exemplo simples do uso do method channel.',
                _mensagem,
                [
                  FlatButton(
                    child: const Text('Obter saudação'),
                    onPressed: _obterMensagem
                  ),
                ]
              ),
            ],
          )));
  }

  Widget _obterCard(String titulo, String subtitulo, String valor, List<Widget> botoes) {
    return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.timer),
              title: Text(titulo),
              subtitle: Text(subtitulo),
            ),
            Center(
              child: Text(valor, style: TextStyle(fontSize: 22),),
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: botoes))
      ]));
  }
}
