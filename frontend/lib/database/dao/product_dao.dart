import 'package:datacaixa/common/database_strings.dart';
import 'package:datacaixa/database/dao/dao_helper.dart';
import 'package:datacaixa/models/product.dart';
import 'package:sqflite/sqlite_api.dart';

class ProductDao implements DaoHelper{

  Database db;
  ProductDao(this.db);

  ProductDao.createTable(Database database){
    createTable(database);
  }

  @override
  void createTable(Database database) async {
    await database.execute(
        "CREATE TABLE $productsTable "
            "($identifier INTEGER PRIMARY KEY AUTOINCREMENT, "
            "$productId INTEGER UNIQUE, "
            "$productGroupId INTEGER, "
            "$description TEXT, "
            "$createdAt TEXT, "
            "$price REAL, "
            "$sales INTEGER)"
    );
  }

  @override
  Future get(int id) async {
      try {
        List<Map> maps = await db.query(productsTable,
            columns: [identifier, productId, productGroupId, description, createdAt, price, sales],
            where: '$identifier = ?',
            whereArgs: [id]
        );
        if(maps.length > 0)
          return Product.fromMap(maps.first);
      } catch (_){

      }
  }

  @override
  Future<List> getAll() async {
    try {
      List<Map> maps = await db.query(productsTable, columns: [identifier, productId, productGroupId, description, createdAt, price, sales]);
      if(maps.length > 0) {
        return maps.map((map) => Product.fromMap(map)).toList();
      }
    } catch(_){}
    return [];
  }

  @override
  void insert(item) async {
    if(item is Product){
      try {
        item.identifier = await db.insert(productsTable, item.toMap());
      } catch(_){}
    }
  }

  @override
  void insertAll(List items) {
    if(items is List<Product>){
      for(Product item in items){
        insert(item);
      }
    }
  }

  @override
  void update(item) async {
    if(item is Product){
      try {
        await db.update(productsTable, item.toMap(), where: '$identifier = ?', whereArgs: [item.identifier]);
      } catch (_){}
    }
  }

  @override
  void remove(item) async {
    if(item is Product){
      try {
        await db.delete(productsTable, where: '$identifier = ?', whereArgs: [item.identifier]);
      } catch(_){}
    }
  }

  @override
  void removeAll(List items) async {
    if(items is List<Product>){
      List<int> ids = items.map((u) => u.productId != null ? u.productId : -1).toList();
      try {
        await db.delete(userTable, where: '$userId NOT IN (${ids.join(', ')})');
      } catch(_){}
    }
  }

  @override
  removeNoneExisting(List newItems) {
    // TODO: implement removeNoneExisting
    throw UnimplementedError();
  }
}