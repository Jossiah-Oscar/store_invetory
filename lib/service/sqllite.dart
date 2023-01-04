import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import '../models/product.dart';

class SqlliteService extends ChangeNotifier {

  //Setter and Getter for current Sales list
  List<Sale> _sales = [];

  set setcurrentSales(List<Sale> sales) {
    _sales = sales;
  }


  List<Sale> get getcurrentSale {
    return _sales;
  }
  ////

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'samaki_atlas.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE Products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, wholesale_price INTEGER, retail_price INTEGER)",
        );
        await database.execute(
          "CREATE TABLE Sales(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, price_per_product DOUBLE, total_price DOUBLE,quantity INTEGER, date TEXT)",
        );
      },
      version: 1,
    );
  }

  Future createItem(Product product) async {
    int result = 0;
    final Database db = await initializeDB();
    final id = await db.insert('Products', product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Product>> getItems() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Products');
    List<Product> products =
        queryResult.map((e) => Product.fromJson(e)).toList();

    // print(products[0].name);
    return products;
  }

  Future createSale(Sale sale) async {
    int result = 0;
    final Database db = await initializeDB();
    final id = await db
        .insert('Sales', sale.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => print("Sale added"));
  }

  Future<List<Sale>> getSales() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Sales');
    List<Sale> sales = queryResult.map((e) => Sale.fromJson(e)).toList();

    // print(sales[0].name);
    return sales;
  }
}
