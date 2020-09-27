import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'main.dart';


class UserManagement {
  storeNewUser(FirebaseUser user, context, name) async {
    File qr;
    var uri = (Uri.parse("https://pierre2106j-qrcode.p.rapidapi.com/api")
    );
    var response1;
    response1 = await http.get(uri.replace(queryParameters: <String, String>{
      "backcolor": "ffffff",
      "pixel": "9",
      "ecl": "L %7C M%7C Q %7C H",
      "forecolor": "000000",
      "type": "text %7C url %7C tel %7C sms %7C email",
      "text": user.uid,

    },), headers: {
      "x-rapidapi-host": "pierre2106j-qrcode.p.rapidapi.com",
      "x-rapidapi-key": "f9f7a1b65fmsh8040df99eaf90e5p164474jsn2ed53a118bcd"
    });


    print("response.body mother: ${response1.body}");


    File file = await DefaultCacheManager().getSingleFile(response1.body);
    var time = DateTime.now();
    StorageUploadTask task;
    print("File: ${file}");


    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('userQrCodes/${user.uid}.png');
    task = firebaseStorageRef.putFile(file);

    StorageTaskSnapshot snapshot = await task.onComplete;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print("DownloadUrl: ${downloadUrl}");



    Firestore.instance.collection('/users').add({
      "displayName": name,
      'signedUpDate': DateFormat("yyyy-MM-dd").format(DateTime.now()),
      'email': user.email,
      'uid': user.uid,
      'qrCodeUrl': downloadUrl,
    }).catchError((e) {
      print(e);
    });
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
        BuildContext context) =>  MyHomePage()), (route) => false);
  }

}
