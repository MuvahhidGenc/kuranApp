import 'package:flutter/material.dart';

class UsersDialog extends StatefulWidget {
  const UsersDialog({Key? key}) : super(key: key);

  @override
  _UsersDialogState createState() => _UsersDialogState();
}

class _UsersDialogState extends State<UsersDialog> {
  final formKey = GlobalKey<FormState>();
  final _nameTxtControl = TextEditingController();
  final _lastNameTxtControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add User"),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 8,
              ),
              buildName,
              SizedBox(
                height: 8,
              ),
              buildLastName,
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {},
          child: Text("Add"),
        ),
      ],
    );
  }

  Widget get buildName => TextFormField(
        controller: _nameTxtControl,
      );

  Widget get buildLastName => TextFormField(
        controller: _lastNameTxtControl,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Name Enter",
        ),
        validator: (name) => name != null && name.isEmpty ? "enter Name" : null,
      );
}
