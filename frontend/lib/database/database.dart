import 'dart:io';
import 'package:datacaixa/database/dao/dao_helper.dart';
import 'package:datacaixa/database/dao/order_dao.dart';
import 'package:datacaixa/database/dao/order_dao.dart';
import 'package:datacaixa/database/dao/product_dao.dart';
import 'package:datacaixa/database/store_queries.dart';
import 'package:datacaixa/database/store_queries_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataStore implements DataStoreHelper {
  Database db;
  String dbName = 'datacaixa.db';
  StoreQueriesHelper storeHelper = StoreQueries();
  String path;
  OrderDao orderDao;
  DaoHelper daoHelper;

  @override
  void create(Database database, int version) async {
    daoHelper.createTable(database);
  }

  @override
  Future<Database> connect() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, dbName);

    bool dbExists = await databaseExists(path);
   if(dbExists)
     await Directory(databasesPath).create(recursive: true);
    db = await openDatabase(path, version: 1, onCreate: create);
    createDaos();
    return db;
  }

  @override
  void createDaos() async {
    daoHelper = OrderDao(db);
    daoHelper = ProductDao(db);

  }

  @override
  void preload() async {

  }

  @override
  void disconnect() async {
    await db.close();
  }

  @override
  void delete() async {
    await deleteDatabase(path);
  }
}

abstract class DataStoreHelper {
  void create(Database db, int version);
  Future<Database> connect();
  void disconnect();
  void createDaos();
  void delete();
  void preload();
}