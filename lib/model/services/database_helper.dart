import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static Database? _database;
  static final instance = DatabaseHelper._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDb();
    return _database;
  }

  setDatabaseToNull() {
    _database = null;
  }

  Future<Database?> initDb() async {
    String path = join(await getDatabasesPath(), 'newsapp.db');

    return await openDatabase(path, version: 1,
        onConfigure: (Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }, onCreate: (Database db, int version) async {
      await db.execute(''' 
          CREATE TABLE user(
          userId INTEGER PRIMARY KEY AUTOINCREMENT,
          fullName TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          imageUrl TEXT
          )
          ''');

      await db.insert('user',{
        'fullName':'newsapp',
        'email':'newsapp@news.com',
        'password':'news1234'
      });

      await db.execute('''
          CREATE TABLE category(
          categoryId INTEGER PRIMARY KEY,
          categoryName TEXT NOT NULL UNIQUE
          )
          ''').whenComplete(() async {
        await db.insert('category', {'categoryId': 1, 'categoryName': 'top'});
        await db.insert(
            'category', {'categoryId': 2, 'categoryName': 'entertainment'});
        await db
            .insert('category', {'categoryId': 3, 'categoryName': 'sports'});
        await db.insert(
            'category', {'categoryId': 4, 'categoryName': 'technology'});
        await db
            .insert('category', {'categoryId': 5, 'categoryName': 'business'});
        await db
            .insert('category', {'categoryId': 6, 'categoryName': 'science'});
        await db
            .insert('category', {'categoryId': 7, 'categoryName': 'health'});
        await db
            .insert('category', {'categoryId': 8, 'categoryName': 'general'});
      });

      await db.execute('''
        CREATE TABLE user_category(
        
        userId INTEGER NOT NULL,
        categoryId INTEGER NOT NULL,
        PRIMARY KEY (userId,categoryId),
        FOREIGN KEY (userId) REFERENCES user(userId) ON UPDATE CASCADE ON DELETE CASCADE,
        FOREIGN KEY (categoryId) REFERENCES category(categoryId) ON UPDATE CASCADE ON DELETE CASCADE
        
          )
        ''');

      await db.execute('''
        CREATE TABLE article(
        
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        url TEXT,
        imageUrl TEXT,
        publishedAt TEXT,
        categoryId INTEGER,
        FOREIGN KEY (categoryId) REFERENCES category (categoryId) ON UPDATE CASCADE ON DELETE CASCADE
  
        )
        ''');

      await db.execute('''
        CREATE TABLE article_bookmark(
        
        articleBookmarkId INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        url TEXT,
        imageUrl TEXT,
        publishedAt TEXT
    
        )
        ''');
    });
  }
}
