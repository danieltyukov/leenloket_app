import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdimCategoriesIndex extends StatefulWidget {
  const AdimCategoriesIndex({Key? key}) : super(key: key);

  static const routeName = '/admin/categories/index';

  @override
  State<AdimCategoriesIndex> createState() => _AdimCategoriesIndexState();
}

class _AdimCategoriesIndexState extends State<AdimCategoriesIndex> {
  final ref = FirebaseDatabase.instance.ref('Categories');

  void _createNewCategory() async {
    final TextEditingController categoryController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Category'),
        content: TextField(
          controller: categoryController,
          decoration: const InputDecoration(labelText: 'Category Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                ref.push().set({'CategoryName': categoryController.text});
              }
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(String key) {
    ref.child(key).remove();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Index Categories'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _createNewCategory,
            ),
          ],
        ),
        body: FirebaseAnimatedList(
          padding: const EdgeInsets.all(15),
          query: ref,
          itemBuilder: (context, snapshot, animation, index) {
            final categoryName =
                snapshot.child('CategoryName').value.toString();
            return GestureDetector(
              onTap: () {},
              child: Card(
                child: ListTile(
                  title: Text(categoryName),
                  subtitle: Text("ID: ${snapshot.key}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCategory(snapshot.key!),
                  ),
                ),
              ),
            );
          },
        ),
      );
}
