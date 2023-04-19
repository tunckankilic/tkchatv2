import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tkchatv2/common/utils/utils.dart';
import 'package:tkchatv2/models/user_model.dart';

final SelectContactsRepositoryProvider = Provider(
  (ref) => SelectContactsRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactsRepository {
  final FirebaseFirestore firestore;
  SelectContactsRepository({required this.firestore});

  //Gets device contacts data
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      log(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection("users").get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedNum =
            selectedContact.phones[0].number.replaceAll(" ", "");
        if (selectedNum == userData.phoneNumber) {
          isFound == true;
        }
        if (!isFound) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("This number doesn't exists on this app"),
            ),
          );
        }
      }
    } catch (e) {}
  }
}
