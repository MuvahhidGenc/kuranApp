import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/user_model.dart';
import '../snippet/hive_boxes.dart';
import '../widgets/usersdialog.dart';

class HiveNoSql extends StatefulWidget {
  const HiveNoSql({Key? key}) : super(key: key);

  @override
  _HiveNoSqlState createState() => _HiveNoSqlState();
}

class _HiveNoSqlState extends State<HiveNoSql> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final box = HiveBoxes.getTransactions();
    // print(box.name.length);

    for (int i = 0; i < box.values.length; i++) {
      // print("$i = ${box.get(i)!.name}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: ValueListenableBuilder<Box<User>>(
          valueListenable: HiveBoxes.getTransactions().listenable(),
          builder: (context, box, _) {
            final user = box.values.toList().cast<User>();

            return buildContent(user)!;
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => UsersDialog(onclickedDone: addUser)),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future addUser(String name, String lastName) async {
    final user = User()
      ..name = name
      ..lastName = lastName;

    final box = HiveBoxes.getTransactions();
    box.add(user);
    // print(box.get(1)!.name);
    //box.put('mykey', transaction);

    // final mybox = Boxes.getTransactions();
    // final myTransaction = mybox.get('key');
    // mybox.values;
    // mybox.keys;
  }

  Widget? buildContent(List<User> users) {
    if (users.isNotEmpty) {
      return Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: users.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int index) {
                  final user = users[index];

                  return buildUser(context, user);
                }),
          )
        ],
      );
    } else {
      return const Text("Veri Yok");
    }
  }

  Card buildUser(BuildContext context, User user) {
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        title: Text(
          user.name! + " " + user.lastName!,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        children: [
          buildButtons(context, user),
        ],
      ),
    );
  }
}

Widget buildButtons(BuildContext context, User user) => Row(
      children: [
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text("Düzenle"),
            onPressed: () =>showDialog(context: context, builder: (context)=> UsersDialog(
                  onclickedDone: (name, lastname) =>
                      editUser(user, name, lastname),
                  user: user,
                ),
              ),
            ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () => deleteUser(user),
            icon: const Icon(Icons.delete),
            label: const Text("Sil"),
          ),
        ),
      ],
    );

deleteUser(User user) {
  user.delete();
}

editUser(User user, String name, String lastname) {
  user.name = name;
  user.lastName = lastname;

  user.save();
}
