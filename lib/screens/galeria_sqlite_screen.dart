import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../db/db_helper.dart';
import '../models/gallery_item.dart';

class GaleriaSQLiteScreen extends StatefulWidget {
  const GaleriaSQLiteScreen({super.key});

  @override
  State<GaleriaSQLiteScreen> createState() => _GaleriaSQLiteScreenState();
}

class _GaleriaSQLiteScreenState extends State<GaleriaSQLiteScreen> {
  final String autor = "LG-9";
  List<GalleryItem> lista = [];

  @override
  void initState() {
    super.initState();
    cargarSoloAutor();
  }

  Future<void> cargarSoloAutor() async {
    final data = await DBHelper.getByAutor(autor);
    setState(() {
      lista = data.map((e) => GalleryItem.fromMap(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Galeria SQLite")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Autor: $autor",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final item = lista[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      width: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    title: Text(item.titulo),
                    subtitle: Text(item.autor),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
