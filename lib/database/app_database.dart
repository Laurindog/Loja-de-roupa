
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transferencia.dart';

Future<Database> getDatabase() async {
  final String path = join(
    await getDatabasesPath(),
    'loja_roupas.db',
  );

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE compras (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          numero_venda INTEGER NOT NULL UNIQUE,
          valor_compra REAL NOT NULL,
          sincronizado INTEGER NOT NULL DEFAULT 1
        )
      ''');
    },
  );
}

// Salva uma compra no SQLite.
Future<int> salvarCompraLocal(CompraRoupa compra) async {
  final Database db = await getDatabase();

  return db.insert(
    'compras',
    compra.toMap()..remove('id'),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Busca todas as compras armazenadas localmente.
Future<List<CompraRoupa>> buscarComprasLocais() async {
  final Database db = await getDatabase();

  final List<Map<String, dynamic>> resultado =
      await db.query('compras', orderBy: 'id DESC');

  return resultado.map((map) => CompraRoupa.fromMap(map)).toList();
}

// Busca somente as compras que ainda não foram sincronizadas.
Future<List<CompraRoupa>> buscarComprasPendentes() async {
  final Database db = await getDatabase();

  final List<Map<String, dynamic>> resultado = await db.query(
    'compras',
    where: 'sincronizado = ?',
    whereArgs: [0],
  );

  return resultado.map((map) => CompraRoupa.fromMap(map)).toList();
}

// Marca uma compra como sincronizada.
Future<void> marcarCompraSincronizada(int id) async {
  final Database db = await getDatabase();

  await db.update(
    'compras',
    {'sincronizado': 1},
    where: 'id = ?',
    whereArgs: [id],
  );
}
