import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mapeando.dart';

Future<Mapeando> buscarServico() async {
  final response = await http.get(Uri.https('rickandmortyapi.com',
      'api/character/1'));

  if (response.statusCode == 200) {
    return Mapeando.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Mapeando');
  }
}

void main() => runApp(LendoJsonPage());

class LendoJsonPage extends StatefulWidget {
  LendoJsonPage({Key key}) : super(key: key);

  @override
  _LendoJsonPageState createState() => _LendoJsonPageState();
}

class _LendoJsonPageState extends State<LendoJsonPage> {
  Future<Mapeando> futureMapeando;

  @override
  void initState() {
    super.initState();
    futureMapeando = buscarServico();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resgatando dados da API - hot-reload',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Resgatando dados da API'),
        ),
        body: Center(
          child: FutureBuilder<Mapeando>(
            future: futureMapeando,
            builder: (context, snapshot) {
              String resultado = snapshot.data.name;
              if (snapshot.hasData) {
                return Text(resultado);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}


