import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdminIndexItems extends StatefulWidget {
  const AdminIndexItems({Key? key}) : super(key: key);

  static const routeName = '/admin/items/index';

  @override
  State<AdminIndexItems> createState() => _AdminIndexItems();
}

class _AdminIndexItems extends State<AdminIndexItems> {
  final ref = FirebaseDatabase.instance.ref('Items');
  final categoriesRef = FirebaseDatabase.instance.ref('Categories');
  final lockersRef = FirebaseDatabase.instance.ref('Lockers');

  void _createNewItem() async {
    final TextEditingController itemNameController = TextEditingController();
    final TextEditingController pricePerDayController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController statusController = TextEditingController();
    String? selectedCategoryID;
    String? selectedLockerID;

    // Fetch categories and lockers for dropdowns
    final categoriesSnapshot = await categoriesRef.get();
    final lockersSnapshot = await lockersRef.get();

    List<DropdownMenuItem<String>> categoryItems =
        categoriesSnapshot.children.map((e) {
      return DropdownMenuItem<String>(
        value: e.key,
        child: Text(e.child('CategoryName').value.toString()),
      );
    }).toList();

    List<DropdownMenuItem<String>> lockerItems =
        lockersSnapshot.children.map((e) {
      return DropdownMenuItem<String>(
        value: e.key,
        child: Text(e.child('Location').value.toString()),
      );
    }).toList();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemNameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: pricePerDayController,
                decoration: const InputDecoration(labelText: 'Price Per Day'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                items: categoryItems,
                onChanged: (String? value) {
                  selectedCategoryID = value;
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Locker'),
                items: lockerItems,
                onChanged: (String? value) {
                  selectedLockerID = value;
                },
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
            onPressed: () {
              if (itemNameController.text.isNotEmpty &&
                  pricePerDayController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  statusController.text.isNotEmpty &&
                  selectedCategoryID != null &&
                  selectedLockerID != null) {
                ref.push().set({
                  'ItemName': itemNameController.text,
                  'PricePerDay': int.parse(pricePerDayController.text),
                  'Description': descriptionController.text,
                  'Status': statusController.text,
                  'CategoryID': selectedCategoryID,
                  'LockerID': selectedLockerID,
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(String key) {
    ref.child(key).remove();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Index Items'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _createNewItem,
            ),
          ],
        ),
        body: FirebaseAnimatedList(
          padding: const EdgeInsets.all(15),
          query: ref,
          itemBuilder: (context, snapshot, animation, index) {
            final itemName = snapshot.child('ItemName').value.toString();
            final itemStatus = snapshot.child('Status').value.toString();
            return GestureDetector(
              onTap: () {
                // Implement onTap functionality if required
              },
              child: Card(
                child: ListTile(
                  title: Text(itemName),
                  subtitle: Text("ID: ${snapshot.key}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(itemStatus),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(snapshot.key!),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
}
