import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' ;
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var moDirectory = await getApplicationDocumentsDirectory();
    var moPath = join(moDirectory.path, 'db_crud');
    var moDatabase =
        await openDatabase(moPath, version: 1, onCreate: _createDatabase);
    return moDatabase;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String lsSql =
        "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,fName TEXT,lName TEXT, contact Text,email "
        "TEXT,dob TEXT,image TEXT, createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)";
    await database.execute(lsSql);
  }
}
