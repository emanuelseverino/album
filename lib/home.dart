import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Foto.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<List<Foto>> pegarFotos(http.Client client) async {
    final response =
        await client.get(Uri.parse('https://minhasapis.com.br/foto'));
    return parseFotos(response.body);
  }

  List<Foto> parseFotos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Foto>((json) => Foto.fromJson(json)).toList();
  }

  final List<Foto> fotos = [];

  String imagem = "https://i.stack.imgur.com/y9DpT.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Fotos',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: FutureBuilder<List<Foto>>(
              future: pegarFotos(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasError){
                  return Center(child: Text('Erro ao carregar dados do Servidor.'),);
                }
                if(!snapshot.hasData){
                  return Center(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LinearProgressIndicator(),
                  ),);
                } else{
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          String url = snapshot.data![index].imagem;
                          setState(() {
                            imagem = url;
                          });
                        },
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 24,
                                bottom: 24
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(snapshot.data![index].imagem)
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

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
                  image: DecorationImage(
                    image: NetworkImage(imagem),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
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
