import 'dart:async';
import 'dart:ffi';

import 'package:sqflite_database/db_helper/repository.dart';
import 'package:sqflite_database/model/User.dart';

class UserService {
  late Repository moRepository;

  UserService() {
    moRepository = Repository();
  }

  //Save User
  saveUser(User user) async {
    return await moRepository.insertData('users', user.userMap());
  }

  //Read All Users
  readAllUsers() async {
    return await moRepository.readData('users');
  }

  //Edit User
  updateUser(User user) async {
    return await moRepository.updateData('users', user.userMap());
  }

  deleteUser(userId) async {
    return await moRepository.deleteDataById('users', userId);
  }

  getUserDetail(Int id) async {
    return await moRepository.getUserAllDetail('users', id);
  }
  checkEmailVerify(String email) async {
    return await moRepository.checkEmail('users', email);
  }

  checkDatabase() async {
    return await moRepository.checkDatabase('users');
  }
}
