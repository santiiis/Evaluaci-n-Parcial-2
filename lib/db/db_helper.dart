import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'galeria.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE galeria(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            imageUrl TEXT,
            autor TEXT
          )
        ''');

        for (int i = 1; i <= 15; i++) {
          await db.insert('galeria', {
            'titulo': 'Imagen $i',
            'imageUrl': 'https://picsum.photos/200/300?random=$i',
            'autor': i % 2 == 0 ? 'LG-9' : 'OTRO-1',
          });
        }
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getByAutor(String autor) async {
    final db = await database;
    return db.query('galeria', where: 'autor = ?', whereArgs: [autor]);
  }
}
