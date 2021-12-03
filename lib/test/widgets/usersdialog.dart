import 'package:flutter/material.dart';
import 'package:kuran/test/model/user_model.dart';

class UsersDialog extends StatefulWidget {
  final User? user;
  final Function(String name, String lastName)? onclickedDone;
  const UsersDialog({Key? key, this.user, @required this.onclickedDone})
      : super(key: key);

  @override
  _UsersDialogState createState() => _UsersDialogState();
}

class _UsersDialogState extends State<UsersDialog> {
  final formKey = GlobalKey<FormState>();
  final _nameTxtControl = TextEditingController();
  final _lastNameTxtControl = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      final users = widget.user!;

      _nameTxtControl.text = users.name!;
      _lastNameTxtControl.text = users.lastName!;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _nameTxtControl.dispose();
    _lastNameTxtControl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Yeni Kullanıcı Ekle"),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 8,
              ),
              buildName,
              const SizedBox(
                height: 8,
              ),
              buildLastName,
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddUser(context)
      ],
    );
  }

  Widget get buildName => TextFormField(
        controller: _nameTxtControl,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "LastName Enter",
        ),
        validator: (name) =>
            name != null && name.isEmpty ? "enter LastName" : null,
      );

  Widget get buildLastName => TextFormField(
        controller: _lastNameTxtControl,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Name Enter",
        ),
        validator: (name) => name != null && name.isEmpty ? "enter Name" : null,
      );

  TextButton buildCancelButton(BuildContext context) => TextButton(
      onPressed: () => Navigator.of(context).pop(), child: Text("Vazgeç"));

  TextButton buildAddUser(BuildContext context) {
    return TextButton(
    
        onPressed: () async{
          final isValid=formKey.currentState!.validate();

          if(isValid){
            final name=_nameTxtControl.text;

            final lastName=_lastNameTxtControl.text;

            widget.onclickedDone!(name,lastName);

            Navigator.of(context).pop();
          }
        },
        child: Text("Ekle"),
      );
      }

}
