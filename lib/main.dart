import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_database/model/User.dart';
import 'package:sqflite_database/screens/EditUser.dart';
import 'package:sqflite_database/screens/ViewUsers.dart';
import 'package:sqflite_database/services/userService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Local Database App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  late List<User> _userList = <User>[];
  final _userService = UserService();
  File? moPickedImage;
  String? msImagePath = "";

  getAllUserDetails() async {
    dynamic users = await _userService.readAllUsers();
    _userList = <User>[];
    if(users.toString() != "[]") {
      users.forEach((user) {
        setState(() {
          isLoading = false;
          var userModel = User();
          userModel.miId = user['id'];
          userModel.msFName = user['fName'];
          userModel.msLName = user['lName'];
          userModel.msContact = user['contact'];
          userModel.msEmail = user['email'];
          userModel.msDob = user['dob'];
          userModel.msImg = user['image'];
          _userList.add(userModel);
        });
      });
    }
    else{
      setState(() {
        _userList.clear();
        print("No Data Found");
      });
      _showSuccessSnackBar('User No Data Found');
      const Text(
        'No Data Found',
        style: TextStyle(
            fontSize: 20,
            color: Colors.teal,
            fontWeight: FontWeight.w500),
      );
    }
  }

  @override
  void initState() {
    getAllUserDetails();
    super.initState();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, userId) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to delete?',
            style: TextStyle(color: Colors.teal, fontSize: 20),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white, // foreground
                  backgroundColor: Colors.red),
              onPressed: () async {
                var result = await _userService.deleteUser(userId);
                if (result != null) {
                  Navigator.pop(context);
                  getAllUserDetails();
                  _showSuccessSnackBar('User Detail Deleted Success');
                }
              },
              child: const Text('Yes'),
            ),
            TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white, // foreground
                    backgroundColor: Colors.teal),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'))
          ],
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQFLite Database"),
      ),
      body: ListView.builder(
          itemCount: _userList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewUser(
                        moUser: _userList[index],
                      ),
                    ),
                  );
                },
                // leading: Text(_userList[index].msImg ?? ''),
                leading: ClipOval(
                  child: _userList[index].msImg != "Image"
                      ? Image.file(
                    File(_userList[index].msImg ?? ''),
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  )
                      : const Icon(
                    Icons.person,
                    color: Colors.teal,
                    size: 50,
                  ),
                ),
                title: Text(_userList[index].msFName ?? ""),
                subtitle: Text(_userList[index].msContact ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUser(
                                miUserId: _userList[index].miId!,
                              ),
                            ),
                          ).then((data) {
                            if (data != null) {
                              getAllUserDetails();
                              _showSuccessSnackBar(
                                  'User Detail Updated Success');
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.teal,
                        )),
                    IconButton(
                      onPressed: () {
                        _deleteFormDialog(context, _userList[index].miId);
                        print("Delete");
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditUser(miUserId: 0)))
              .then((data) {
            if (data != null) {
              getAllUserDetails();
              _showSuccessSnackBar('User Detail Added Success');
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
