import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';

class FirestoreApi {
  static Future uploadContacts(List<Contact> contacts) async {
    final contactsJson = contacts.map((contact) => contact.toMap()).toList();

    final refUser = FirebaseFirestore.instance.collection('users');

    await refUser.add({
      'username': 'alex',
      'contacts': contactsJson,
    });
  }
}
