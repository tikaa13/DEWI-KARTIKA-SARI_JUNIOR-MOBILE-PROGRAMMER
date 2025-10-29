import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/order_model.dart';

class DBService {
  DBService._privateConstructor();
  static final DBService instance = DBService._privateConstructor();

  static Database? _database;

  Future<void> init() async {
    await database;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('toko_roti.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER,
        product_name TEXT,
        price REAL,
        customer_name TEXT,
        customer_phone TEXT,
        latitude REAL,
        longitude REAL,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertOrder(OrderModel order) async {
    final db = await database;
    return await db.insert('orders', order.toMap());
  }

  Future<List<OrderModel>> fetchOrders() async {
    final db = await database;
    final maps = await db.query('orders', orderBy: 'id DESC');
    return maps.map((m) => OrderModel.fromMap(m)).toList();
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
