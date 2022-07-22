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
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          child: ClipOval(
                            child: msImagePath != "Image"
                                ? Image.file(
                                    moPickedImage!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.person,
                                    color: Colors.teal,
                                    size: 150,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
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
