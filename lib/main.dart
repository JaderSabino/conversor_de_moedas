import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=bc37fed3";

void main() async {
  print(await getData());

  Container;

  runApp(MaterialApp(title: "Conversor de Moedas", home: Home()));
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realControler = TextEditingController();
  final dolarControler = TextEditingController();
  final euroControler = TextEditingController();

  double dolar;
  double euro;

  void _realChange(String valor) {
    if (valor == "") {
      dolarControler.text = "";
      euroControler.text = "";
    }
    double real = double.parse(valor);
    dolarControler.text = (real / dolar).toStringAsFixed(2);
    euroControler.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChange(String valor) {
    if (valor == "") {
      realControler.text = "";
      euroControler.text = "";
    }
    double dolar = double.parse(valor);
    realControler.text = (dolar * this.dolar).toStringAsFixed(2);
    euroControler.text = ((dolar * this.dolar) / euro).toStringAsFixed(2);
  }

  void _euroChange(String valor) {
    if (valor == "") {
      realControler.text = "";
      dolarControler.text = "";
    }
    double euro = double.parse(valor);
    realControler.text = (euro * this.euro).toStringAsFixed(2);
    dolarControler.text = ((euro * this.euro) / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(color: Colors.amber),
                  textAlign: TextAlign.center,
                ),
              );
              break;
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar os dados",
                    style: TextStyle(color: Colors.amber),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150, color: Colors.amber),
                        buildTextField(
                            "Reais", "R\$", realControler, _realChange),
                        Divider(),
                        buildTextField(
                            "Dolar", "\$", dolarControler, _dolarChange),
                        Divider(),
                        buildTextField("Euro", "€", euroControler, _euroChange),
                      ],
                    ));
              }
          }
        },
      ),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

Widget buildTextField(String label, String prefix,
    TextEditingController controler, Function change) {
  return Theme(
    data: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber)))),
    child: TextField(
      controller: controler,
      onChanged: change,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(color: Colors.amber, fontSize: 25),
    ),
  );
}
