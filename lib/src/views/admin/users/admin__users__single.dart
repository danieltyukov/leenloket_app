import 'package:Leenloket/src/models/credit_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Leenloket/src/models/user_model.dart' as userModel;

/// Displays detailed information about a SampleItem.
class AdminUserSingle extends StatefulWidget {
  final String userID;

  const AdminUserSingle({super.key, required this.userID});

  static const routeName = '/admin/users/single';
  @override
  State<AdminUserSingle> createState() => _AdminUserSingle();
}

class _AdminUserSingle extends State<AdminUserSingle> {
  late DatabaseReference _userRef;

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.ref('Users/${widget.userID}');
  }

  Future<DatabaseEvent> fetchUser(String userID) async {
    return await _userRef.once();
  }

  @override
  Widget build(BuildContext context) {
    Credit creditInstance = Credit(credit: 0.00, userID: widget.userID);
    userModel.User selectedUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User details'),
      ),
      body: FutureBuilder(
        future: fetchUser(widget.userID),
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('Data not available');
          } else {
            DataSnapshot userSnapshot = snapshot.data!.snapshot;

            selectedUser = userModel.User(
                id: widget.userID,
                name: userSnapshot.child('Name').value.toString(),
                email: userSnapshot.child('Email').value.toString(),
                phone: userSnapshot.child('Phone').value.toString(),
                address: userSnapshot.child('Address').value.toString(),
                roleID: userSnapshot.child('RoleID').value.toString(),
                password: userSnapshot.child('Password').value.toString());

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.red.withOpacity(0.4),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Name: ${selectedUser.name}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Email: ${selectedUser.email}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Address: ${selectedUser.address}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Phone: ${selectedUser.phone}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder(
                        future: selectedUser.fetchDoubleCredit(),
                        builder: (context, AsyncSnapshot<double> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return const Text('Data not available');
                          } else {
                            return Card(
                              child: ListTile(
                                title: const Text('Credit'),
                                trailing: Text(snapshot.data.toString()),
                              ),
                            );
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    AddCreditDialog(selectedUser: selectedUser),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class AddCreditDialog extends StatelessWidget {
  const AddCreditDialog({
    super.key,
    required this.selectedUser,
  });

  final userModel.User selectedUser;

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    return ElevatedButton(
      onPressed: () {
        //Add credit dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Add credit'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (amountController.text.isNotEmpty) {
                    final double amount = double.parse(amountController.text);

                    selectedUser.topCredit(amount);
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add credit',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: BorderSide.none,
          foregroundColor: Colors.white),
      child: const Text('Add credit'),
    );
  }
}
