class Foto{
  final int id;
  final String imagem;
  final String titulo;

  Foto({
    required this.id,
    required this.imagem,
    required this.titulo
  });

  factory Foto.fromJson(Map<String, dynamic> json){
    return Foto(
        id: json['id'],
        imagem: json['imagem'],
        titulo:json['titulo']
    );
  }
}