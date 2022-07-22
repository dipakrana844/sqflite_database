import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_database/model/User.dart';
import 'package:sqflite_database/services/userService.dart';
import 'package:form_field_validator/form_field_validator.dart';

class EditUser extends StatefulWidget {
  final int miUserId;

  const EditUser({Key? key, required this.miUserId}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var moUserService = UserService();
  DateTime? moDate;
  File? moPickedImage ;
  String? msImagePath = "Image";

  final moUserFirstNameController = TextEditingController();
  final moUserLastNameController = TextEditingController();
  final moUserContactController = TextEditingController();
  final moUserEmailController = TextEditingController();
  final moUserDobController = TextEditingController();

  bool mbFName = false;
  bool mbLName = false;
  bool mbContact = false;
  bool mbEmail = false;
  bool mbDob = false;

  String msEmailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  // validate() {
  //   if (formKey.currentState!.validate()) {
  //     print("validated");
  //   } else {
  //     print("Not Validated");
  //   }
  // }

  String? validateFName(value) {
    if (value!.isEmpty) {
      mbFName = false;
      return "Required";
    }
    mbFName = true;
    return null;
  }

  String? validateLName(value) {
    if (value!.isEmpty) {
      mbLName = false;
      return "Required";
    }
    mbLName = true;
    return null;
  }

  String? validateContact(value) {
    if (value!.isEmpty) {
      mbContact = false;
      return "Required";
    } else if (value.length < 10) {
      mbContact = false;
      return "Invalid";
    } else if (value.length > 10) {
      mbContact = false;
      return "Invalid";
    }
    mbContact = true;
    return null;
  }

  // !RegExp(msEmailPattern).hasMatch(moUserEmailController.text)
  String? validateEmail(value) {
    if (value!.isEmpty) {
      mbEmail = false;
      return "Required";
    } else if (!RegExp(msEmailPattern).hasMatch(value)) {
      mbEmail = false;
      return "Invalid";
    }
    mbEmail = true;
    return null;
  }

  String? validateDob(value) {
    if (value!.isEmpty) {
      mbDob = false;
      return "Required";
    }
    mbDob = true;
    return null;
  }

  // String? msValidateFirstName;
  // String? msValidateLastName;
  // String? msValidateContact;
  // String? msValidateEmail;
  // String? msValidateDob;

  // String msContactPattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  getUserData(int fiId) async {
    if (widget.miUserId != 0) {
      var loUser = await UserService()
          .moRepository
          .readDataById('users', widget.miUserId);
      setState(() {
        moUserFirstNameController.text = loUser[0]['fName'];
        moUserLastNameController.text = loUser[0]['lName'] ?? '';
        moUserContactController.text = loUser[0]['contact'] ?? '';
        moUserEmailController.text = loUser[0]['email'] ?? '';
        moUserDobController.text = loUser[0]['dob'] ?? '';
        moDate = DateFormat('dd-MM-yyyy').parse(loUser[0]['dob'] ?? '');
        msImagePath = loUser[0]['image'];
        moPickedImage = File(msImagePath!);
      });
    }
  }

  @override
  void initState() {
    getUserData(widget.miUserId);
    super.initState();
  }

  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageType) async {
    try {
      final loPhoto = await ImagePicker().pickImage(source: imageType);
      if (loPhoto == null) return;
      moPickedImage = File(loPhoto.path);
      setState(() {
        // moPickedImage = loTempImage;
        msImagePath = loPhoto.path;
      });
      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.miUserId == 0 ? 'Add New User' : "Edit New User"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
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
                          Container(
                            // margin: const EdgeInsets.all(0.0),
                            // padding: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Positioned(
                              // bottom: 0,
                              // right: 10,
                              child: IconButton(
                                onPressed: imagePickerOption,
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 25,
                                ),
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
                // const Text(
                //   'Edit New User',
                //   style: TextStyle(
                //       fontSize: 20,
                //       color: Colors.teal,
                //       fontWeight: FontWeight.w500),
                // ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: moUserFirstNameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: 'Enter First Name',
                    labelText: 'First Name',
                    // errorText: msValidateFirstName,
                  ),
                  // validator: RequiredValidator(errorText: "Required"),
                  validator: validateFName,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: moUserLastNameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: 'Enter Last Name',
                    labelText: 'Last Name',
                    // errorText: msValidateLastName,
                  ),
                  validator: validateLName,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: moUserContactController,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: 'Enter Contact Number',
                    labelText: 'Contact',
                    // errorText: msValidateContact,
                  ),
                  validator: validateContact,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: moUserEmailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: 'Enter Email',
                    labelText: 'Email',
                    // errorText: msValidateEmail,
                  ),
                  validator: validateEmail,
                  // validator: MultiValidator([
                  //   RequiredValidator(errorText: "Required"),
                  //   EmailValidator(errorText: "Invalid"),
                  // ]),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () async {
                    final loInitialDate = DateTime.now();
                    final loPickedDate = await showDatePicker(
                      context: context,
                      initialDate: moDate ?? loInitialDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (loPickedDate != null) {
                      String msFormattedDate =
                          DateFormat('dd-MM-yyyy').format(loPickedDate);
                      setState(() {
                        moUserDobController.text = msFormattedDate;
                        moDate = loPickedDate;
                        // mbDob = true;
                      });
                    } else {
                      print("Date is not selected");
                      // mbDob = false;
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: moUserDobController,
                      decoration: const InputDecoration(
                        prefixIcon:
                            Icon(Icons.calendar_today, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        // errorText: msValidateDob == "" ? 'Save' : 'Update',
                        labelText: "Enter DOB",
                        hintText: 'Enter Date of Birth',
                        // errorText: msValidateDob ? 'Required' : null,
                      ),
                      // readOnly: true,
                      validator: validateDob,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.teal,
                            textStyle: const TextStyle(fontSize: 15)),
                        onPressed: () async {
                          // setState(() {
                          //   validate();
                          // });
                          if (mbFName &&
                              mbLName &&
                              mbContact &&
                              mbEmail &&
                              mbDob) {
                            // if (await moUserService.checkEmailVerify(
                            //         moUserEmailController.text) !=
                            //     0) {
                            //   msValidateEmail =  "Required!!!";
                            // } else {
                            //   mbEmail = true;
                            // print("Good Data Can Save");

                            var loUser = User();
                            if (widget.miUserId == 0) {
                              loUser.msFName = moUserFirstNameController.text;
                              loUser.msLName = moUserLastNameController.text;
                              loUser.msContact = moUserContactController.text;
                              loUser.msEmail = moUserEmailController.text;
                              loUser.msDob = moUserDobController.text;
                              loUser.msImg = msImagePath;
                              var loResult =
                                  await moUserService.saveUser(loUser);
                              Navigator.pop(context, loResult);
                            } else {
                              loUser.miId = widget.miUserId;
                              loUser.msFName = moUserFirstNameController.text;
                              loUser.msLName = moUserLastNameController.text;
                              loUser.msContact = moUserContactController.text;
                              loUser.msEmail = moUserEmailController.text;
                              loUser.msDob = moUserDobController.text;
                              loUser.msImg = msImagePath;
                              moPickedImage = File(msImagePath!);
                              var loResult =
                                  await moUserService.updateUser(loUser);
                              Navigator.pop(context, loResult);
                            }
                          }
                          // } else {
                          //   print("Print Enter Date");
                          // }
                        },
                        child: Text(widget.miUserId == 0 ? 'Save' : 'Update')),
                    const SizedBox(
                      width: 10.0,
                    ),
                    // TextButton(
                    //     style: TextButton.styleFrom(
                    //         primary: Colors.white,
                    //         backgroundColor: Colors.red,
                    //         textStyle: const TextStyle(fontSize: 15)),
                    //     onPressed: () {
                    //       moUserFirstNameController.text = '';
                    //       moUserLastNameController.text = '';
                    //       moUserContactController.text = '';
                    //       moUserEmailController.text = '';
                    //       moUserDobController.text = '';
                    //     },
                    //     child: const Text('Clear'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
