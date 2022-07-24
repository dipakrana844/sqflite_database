import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_database/model/User.dart';

class ViewUser extends StatefulWidget {
  final User moUser;

  const ViewUser({Key? key, required this.moUser}) : super(key: key);

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  File? moPickedImage;
  String? msImagePath;

  @override
  void initState() {
    setState(() {
      msImagePath = widget.moUser.msImg!;
      moPickedImage = File(widget.moUser.msImg!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Details"),
          actions: const [
            // IconButton(onPressed: () => {}, icon: const Icon(Icons.search))
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 400,
                  height: 300,
                  decoration: BoxDecoration(
                      // add border
                      border: Border.all(
                          width: 5, color: Colors.tealAccent.shade200),
                      // add drop shadow
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(10, 10),
                            blurRadius: 2,
                            spreadRadius: 2,
                            color: Colors.grey.shade300)
                      ]),
                  // implement image
                  child: msImagePath != "Image"
                      ? Image.file(
                          moPickedImage!,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.teal,
                          size: 300,
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('Id',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(widget.moUser.miId.toString(),
                        style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('First Name',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(widget.moUser.msFName ?? '',
                        style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('Last Name',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(widget.moUser.msLName ?? '',
                        style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('Contact Number',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(widget.moUser.msContact ?? '',
                        style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('Email Id',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(widget.moUser.msEmail ?? '',
                        style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('Date of Birth',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(widget.moUser.msDob ?? '',
                        style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
