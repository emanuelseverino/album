import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Foto.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Foto> fotosCarregadas;

  Future<Foto> pegarFotos() async {
    final response =
    await http.get(Uri.parse("https://minhasapis.com.br/foto"));
    if (response.statusCode == 200) {
      return Foto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Erro ao carregar foto");
    }
  }

  @override
  void initState() {
    super.initState();
    fotosCarregadas = pegarFotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Photos',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: FutureBuilder<Foto>(
              future: fotosCarregadas,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // itemCount: fotosCarregadas.data!.length,
                    itemBuilder: (context, index){
                      return Text('${snapshot.data!.titulo}');
                    },);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 24,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_a_photo_outlined),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_photo_alternate_outlined),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
