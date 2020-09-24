import 'package:contacts_example/api/firestore_api.dart';
import 'package:contacts_example/contact_utils.dart';
import 'package:contacts_example/main.dart';
import 'package:contacts_example/page/home_page.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    askContactsPermission();
  }

  Future askContactsPermission() async {
    final permission = await ContactUtils.getContactPermission();
    switch (permission) {
      case PermissionStatus.granted:
        uploadContacts();
        break;
      case PermissionStatus.permanentlyDenied:
        goToHomePage();
        break;
      default:
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content: Text('Please allow to "Upload Contacts"'),
            duration: Duration(seconds: 3),
          ),
        );
        break;
    }
  }

  Future uploadContacts() async {
    final contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();

    await FirestoreApi.uploadContacts(contacts);

    goToHomePage();
  }

  void goToHomePage() => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        ModalRoute.withName('/'),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Text(
                  'Enable app permissions to upload contacts',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Container(
                  height: 150,
                  child: Image.asset('assets/contacts.png'),
                ),
                SizedBox(height: 32),
                Text(
                  'Tap Allow when prompted',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Spacer(),
                const SizedBox(height: 32),
                buildButton(context, 'Upload Contacts', askContactsPermission),
                const SizedBox(height: 32),
                buildButton(context, 'Continue', goToHomePage),
              ]),
        ),
      ),
    );
  }

  Widget buildButton(
          BuildContext context, String text, VoidCallback onPressed) =>
      Container(
        height: 50,
        width: 170,
        child: RaisedButton(
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
          onPressed: onPressed,
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          shape: StadiumBorder(),
          //shape: StadiumBorder(),
        ),
      );
}
