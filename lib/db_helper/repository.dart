import 'package:sqflite/sqflite.dart';
import 'package:sqflite_database/db_helper/database_connection.dart';

class Repository {
  var moDatabaseConnection;

  Repository() {
    moDatabaseConnection = DatabaseConnection();
  }

  static Database? moDatabase;

  Future<Database?> get database async {
    if (moDatabase != null) {
      return moDatabase;
    } else {
      moDatabase = await moDatabaseConnection.setDatabase();
      return moDatabase;
    }
  }

  insertData(table, data) async {
    var loConnection = await database;
    return await loConnection?.insert(table, data);
  }

  readData(table) async {
    var loConnection = await database;
    return await loConnection?.query(table);
  }

  readDataById(table, itemId) async {
    var loConnection = await database;
    return await loConnection?.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  updateData(table, data) async {
    var loConnection = await database;
    return await loConnection
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteDataById(table, itemId) async {
    var loConnection = await database;
    return await loConnection?.rawDelete("delete from $table where id=$itemId");
  }

  checkEmail(table, email) async {
    var loConnection = await database;
    var loX = await loConnection?.query(table,
        columns: ['email'], where: 'email=?', whereArgs: [email]);
    print("Your Count is : +${loX.toString()}");
    print("Your Count is : +${loX.toString() == '[]' ? true : false}");
    return loX.toString() != '[]' ? false : true;
  }


  checkDatabase(table) async {
    var loConnection = await database;
    var loCount = await loConnection?.rawQuery("SELECT COUNT(*) FROM $table");
    print(loCount);
    return loCount;
  }

  getUserAllDetail(table, id) async {
    var loConnection = await database;
    return await loConnection?.rawQuery("select * from $table where id=$id");
  }
}
