class User {
  int? miId;
  String? msFName;
  String? msLName;
  String? msContact;
  String? msEmail;
  String? msDob;
  String? msImg;
  userMap() {
    var moMapping = <String, dynamic>{};
    moMapping['id'] = miId;
    moMapping['fName'] = msFName!;
    moMapping['lName'] = msLName!;
    moMapping['contact'] = msContact!;
    moMapping['email'] = msEmail!;
    moMapping['dob'] = msDob!;
    moMapping['image'] = msImg!;
    return moMapping;
  }
}
