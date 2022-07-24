import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_database/model/User.dart';
import 'package:sqflite_database/screens/EditUser.dart';
import 'package:sqflite_database/screens/ViewUsers.dart';
import 'package:sqflite_database/services/userService.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material();
  };
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
  // bool isLoading = true;
  late List<User> moUserList = <User>[];
  final moUserService = UserService();
  File? moPickedImage;
  String? msImagePath = "";

  void _fetchData(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    await Future.delayed(const Duration(seconds: 3));

    // Close the dialog programmatically
    Navigator.of(context).pop();
  }

  getAllUserDetails() async {
    dynamic moUsers = await moUserService.readAllUsers();
    moUserList = <User>[];
    if (moUsers.toString() != "[]") {
      moUsers.forEach((user) {
        setState(() {
          // isLoading = false;
          var moUserModel = User();
          moUserModel.miId = user['id'];
          moUserModel.msFName = user['fName'];
          moUserModel.msLName = user['lName'];
          moUserModel.msContact = user['contact'];
          moUserModel.msEmail = user['email'];
          moUserModel.msDob = user['dob'];
          moUserModel.msImg = user['image'];
          moUserList.add(moUserModel);
        });
      });
    } else {
      setState(() {
        moUserList.clear();
        print("No Data Found");
      });
      // _showSuccessSnackBar('User No Data Found');
      const Text(
        'No Data Found',
        style: TextStyle(
            fontSize: 20, color: Colors.teal, fontWeight: FontWeight.w500),
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
                var loResult = await moUserService.deleteUser(userId);
                if (loResult != null) {
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
        title: const Text("SQFlite Database App"),
        actions: const [
          // IconButton(onPressed:  , icon: const Icon(Icons.search))
        ],
        backgroundColor: Colors.teal[500],
        actionsIconTheme: const IconThemeData(color: Colors.amber, size: 36),
        elevation: 15,
        shadowColor: Colors.orangeAccent,
        toolbarTextStyle: TextTheme(
          headline6: TextStyle(
            color: Colors.amber[200],
            fontSize: 24,
          ),
        ).bodyText2,
        titleTextStyle: TextTheme(
          headline6: TextStyle(
            color: Colors.amber[200],
            fontSize: 24,
          ),
        ).headline6,
      ),
      body: moUserList.toString() == "[]"
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '🚫 No Data Found 🚫',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.teal,
                        fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: moUserList.length,
              itemBuilder: (context, index) {
                // _fetchData(context);
                return Card(
                  elevation: 4,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 0, right: 0),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              color: Colors.amber.shade700, width: 8),
                          right: BorderSide(
                              color: Colors.amber.shade700, width: 8),
                          // top: BorderSide(color: Colors.amber.shade100, width: 5),
                          // bottom: BorderSide(color: Colors.amber.shade100, width: 5),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewUser(
                                moUser: moUserList[index],
                              ),
                            ),
                          );
                        },
                        leading: ClipOval(
                          child: moUserList[index].msImg != "Image"
                              ? Image.file(
                                  File(moUserList[index].msImg ?? ''),
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
                        title: Text(
                            "${moUserList[index].msFName}  ${moUserList[index].msLName}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              moUserList[index].msContact ?? '',
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w100),
                            ),
                            Text(
                              moUserList[index].msEmail ?? '',
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w100),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditUser(
                                        miUserId: moUserList[index].miId!,
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
                                _deleteFormDialog(
                                    context, moUserList[index].miId);
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
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(),
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
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.edit,
          size: 20.0,
        ),
      ),
    );
  }
}
