import 'package:garuda_industries/JSON/detail_penjualan.dart';
import 'package:garuda_industries/JSON/penjualan.dart';
import 'package:garuda_industries/JSON/product.dart';
import 'package:garuda_industries/JSON/users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "garuda_preinstal11.db";

  // Tables

  // Don't put a comma at the end of a column in sqlite
  String user = '''
  CREATE TABLE users (
    usrId INTEGER PRIMARY KEY AUTOINCREMENT,
    fullName TEXT CHECK(length(fullName) <= 255),
    NomorTelepon INTEGER CHECK(length(NomorTelepon) <= 15),
    Alamat TEXT, 
    usrName TEXT CHECK(length(usrName) <= 255) UNIQUE,
    usrPassword TEXT
  )
  ''';

  // Inside DatabaseHelper class
  String product = '''
    CREATE TABLE produk (
      ProdukID INTEGER PRIMARY KEY AUTOINCREMENT,
      NamaProduk TEXT CHECK(length(NamaProduk) <= 255),
      Gambar TEXT,
      Harga TEXT,
      Stok INTEGER CHECK(length(Stok) <= 11)
    )
  ''';

  String penjualan = '''
    CREATE TABLE penjualan (
      PenjualanID INTEGER PRIMARY KEY AUTOINCREMENT,
      TanggalPenjualan DATE,
      TotalHarga INTEGER,
      usrId INTEGER,
      FOREIGN KEY (usrId) REFERENCES users(usrId)
    )
  ''';

  String detailPenjualan = '''
    CREATE TABLE detailpenjualan (
      DetailID INTEGER PRIMARY KEY AUTOINCREMENT,
      PenjualanID INTEGER,
      ProdukID INTEGER,
      JumlahProduk INTEGER,
      Subtotal INTEGER,
      FOREIGN KEY (PenjualanID) REFERENCES penjualan(PenjualanID),
      FOREIGN KEY (ProdukID) REFERENCES produk(ProdukID)
    )
  ''';

  // Our connection is ready
  /*  the initDB() function initializes a database connection, retrieves the path to the database file, 
  opens the database at that path, creates database tables if they do not exist, and returns the database 
  instance for further use. The function handles asynchronous operations to ensure that database-related tasks 
  are executed correctly and efficiently. */
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(user);
      await db.execute(product);
      await db.execute(penjualan);
      await db.execute(detailPenjualan);
    });
  }

  // Function methods

  // Authentication
  // usr = input, var = declare variable
  Future<bool> authenticate(Users usr) async {
    final Database db = await initDB();
    var res = await db.rawQuery(
        "select * from users where usrName = '${usr.usrName}' AND usrPassword = '${usr.password}' ");
    if (res.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Sign Up
  /* usr.toMap() converts the usr object (of type Users) into a map representation. 
  This is likely a method defined in the Users class that converts the object's properties into a map of key-value pairs. */
  Future<int> createUser(Users usr) async {
    final Database db = await initDB();
    return db.insert("users", usr.toMap());
  }

  // Get current User details
  // to check if user has the same username in signup
  /* the ? placeholder is used within the where clause to indicate where the value(s) from the whereArgs parameter should be substituted into the SQL query. This approach ensures that the value(s) provided as arguments are properly sanitized and escaped before being included in the query, reducing the risk of SQL injection attacks. */
  Future<Users?> getUser(String usrName) async {
    final Database db = await initDB();
    var res =
        await db.query("users", where: "usrName = ?", whereArgs: [usrName]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  // Check User Exist, if there is duplicate user, we catch the exception and show a message
  Future<bool> checkUserExist(String username) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> res =
        await db.query("users", where: "usrName = ?", whereArgs: [username]);
    return res.isNotEmpty;
  }

  // View Database List
  /* The query retrieves all rows from the "users" table and stores the result in a list of maps (List<Map<String, dynamic>>). */
  Future<List<Users>> getAllUsers() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('users');

    // generate list
    // i means iteratively
    /* (i) represents the index variable used during iterations, and it helps access the elements of the maps list to initialize properties of the DetailPenjualan objects */
    /* (i) is used to iterate over the indices of the maps list, allowing access to the map entries at each index to initialize properties of the DetailPenjualan objects being created */
    return List.generate(maps.length, (i) {
      return Users(
        usrId: maps[i]['usrId'],
        fullName: maps[i]['fullName'],
        NomorTelepon: maps[i]['NomorTelepon'],
        Alamat: maps[i]['Alamat'],
        usrName: maps[i]['usrName'],
        password: maps[i]['usrPassword'],
      );
    });
  }

  Future<int> deleteUser(int usrId) async {
    final Database db = await initDB();
    return await db.delete(
      'users',
      where: 'usrId = ?',
      whereArgs: [usrId],
    );
  }

  Future<int> updateUser(Users user) async {
    final Database db = await initDB();
    return await db.update(
      'users',
      user.toMap(),
      where: 'usrId = ?',
      whereArgs: [user.usrId],
    );
  }

  /* Function for Product */

  Future<int> createProduct(Product product) async {
    final Database db = await initDB();
    return db.insert("produk", product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('produk');

    return List.generate(maps.length, (i) {
      return Product(
        ProdukID: maps[i]['ProdukID'],
        NamaProduk: maps[i]['NamaProduk'],
        Gambar: maps[i]['Gambar'],
        Harga: maps[i]['Harga'],
        Stok: maps[i]['Stok'],
      );
    });
  }

  Future<int> deleteProduct(int id) async {
    final Database db = await initDB();
    return await db.delete(
      'produk',
      where: 'ProdukID = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateProduct(Product product) async {
    final Database db = await initDB();
    return await db.update(
      'produk',
      product.toMap(),
      where: 'ProdukID = ?',
      whereArgs: [product.ProdukID],
    );
  }

  // Function to insert Penjualan into the database
  Future<int> insertPenjualan(Penjualan penjualan) async {
    final db = await initDB();
    return db.insert(
      'penjualan',
      penjualan.toMap(),
      /* which means that if there is a conflict, the existing row will be replaced with the new data: If the Primary Key Already Exists, replace with new */
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Function to retrieve all Penjualan from the database
  Future<List<Penjualan>> getAllPenjualan() async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('penjualan');
    return List.generate(maps.length, (i) {
      return Penjualan(
        PenjualanID: maps[i]['PenjualanID'],
        TanggalPenjualan: DateTime.parse(maps[i]['TanggalPenjualan']),
        TotalHarga: maps[i]['TotalHarga'],
        usrId: maps[i]['usrId'],
      );
    });
  }

  Future<int> insertDetailPenjualan(DetailPenjualan detailPenjualan) async {
    final db = await initDB();
    return db.insert(
      'detailpenjualan',
      detailPenjualan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DetailPenjualan>> getAllDetailPenjualan(int penjualanID) async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'detailpenjualan',
      where: 'PenjualanID = ?',
      whereArgs: [penjualanID],
    );
    return List.generate(maps.length, (i) {
      return DetailPenjualan(
        DetailID: maps[i]['DetailID'],
        PenjualanID: maps[i]['PenjualanID'],
        ProdukID: maps[i]['ProdukID'],
        JumlahProduk: maps[i]['JumlahProduk'],
        Subtotal: maps[i]['Subtotal'],
      );
    });
  }

  Future<void> deletePenjualan(int penjualanID) async {
    final db = await initDB();
    await db.transaction((txn) async {
      await txn.delete(
        'penjualan',
        where: 'PenjualanID = ?',
        whereArgs: [penjualanID],
      );
      await txn.delete(
        'detailpenjualan',
        where: 'PenjualanID = ?',
        whereArgs: [penjualanID],
      );
    });
  }
}
